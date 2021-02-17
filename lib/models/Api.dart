import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:svt_app/models/Coordinate.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/models/Orario.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/SearchResult.dart';


class Api
{
  static Stream<List<Linea>> ottieniLinee() async*
  {
    yield (Hive.box("cache").get("linee") as List)?.whereType<Linea>()?.toList();

    final response = await Dio().post("http://www.mobilitaveneto.net/TP/SVT/StampaOrari/GetDatiLineeSelezionate");

    if (response.statusCode != 200)
    {
      throw Exception("Impossibile ottenere le linee");
    }

    final List<Linea> linee = (response.data as List).map((linea) => Linea.fromJson(linea)).toList();

    await Hive.box("cache").put("linee", linee);

    yield linee;
  }

  static Future<List<SearchResult>> ricerca(String query) async
  {
    final response = await Dio().post("http://www.mobilitaveneto.net/TP/SVT/Search/Search", queryParameters: {
      "page": 1,
      "rows": 15,
      "searchTerm": query,
    });

    final List<SearchResult> items = (response.data["rows"] as List).map((item) => SearchResult.fromJson(item)).toList();

    return items;
  }

  static Future<Coordinate> ottieniCoordinate(String comuneIstat, String idVia) async
  {
    final response = await Dio().get("http://veneto.mycicero.it/PlusGeocoderWS/geocoderws.svc/sgc/$comuneIstat/$idVia/");

    return Coordinate(
      latitudine: response.data["Coordinate"]["Latitude"],
      longitudine: response.data["Coordinate"]["Longitude"],
    );
  }

  static Future<Coordinate> fromEpsg32632ToEpsg4326(Coordinate coordinate) async
  {
    final response = await Dio().get("https://epsg.io/trans?x=${coordinate.longitudine}&y=${coordinate.latitudine}&s_srs=32632&t_srs=4326&format=json");

    return Coordinate(
      latitudine: num.parse(response.data["y"]),
      longitudine: num.parse(response.data["x"]),
    );
  }

  static Future<void> cercaSoluzioniDiViaggio(SearchResult partenza, SearchResult destinazione) async
  {
    final DateTime date = DateTime.now();

    final Coordinate coordinatePartenza = await partenza.ottieniCoordinate();
    final Coordinate coordinateDestinazione = await destinazione.ottieniCoordinate();

    final response = await Dio().post(
      "http://www.mobilitaveneto.net/TP/SVT/Tp/TrovaSoluzioniViaggio",
      data: FormData.fromMap({
        "pLat": coordinatePartenza.latitudine,
        "pLng": coordinatePartenza.longitudine,
        "dLat": coordinateDestinazione.latitudine,
        "dLng": coordinateDestinazione.longitudine,
        "data": "${_fixData(date.day)}/${_fixData(date.month)}/${date.year}",
        "ora": "00:00",
        "tipoMezzo": -1,
        "tipoSoluzione": 0,
        "jsonTappe": "[]",
      }),
    );

    print(response.data);
  }

  static String _fixData(int parametro) => parametro.toString().padLeft(2, '0');

  static Stream<List<Localita>> ottieniLocalita(String idLinea, int direzione) async* {
    yield (Hive.box("cache").get("localita-$idLinea-$direzione") as List)?.whereType<Localita>()?.toList();

    DateTime dataOdierna = DateTime.now();
    Dio dio = Dio();
    Map<String, dynamic> richiesta = new Map<String, dynamic>();

    richiesta["linea"] = idLinea;
    richiesta["direzione"] = direzione;
    richiesta["di"] = "${_fixData(dataOdierna.day)}/${_fixData(dataOdierna.month)}/${dataOdierna.year}";
    richiesta["codLineaUtenza"] = idLinea;
    richiesta["vector"] = "SOCIETA VICENTINA TRASPORTI s.r.l.";
    richiesta["codAzienda"] = "SVT";
    FormData formData = FormData.fromMap(richiesta);

    Response risposta = await dio.post("http://www.mobilitaveneto.net/TP/SVT/StampaOrari/GetOrariLinea", data: formData);

    if (risposta.statusCode != 200) throw Exception("impossibile ottenre le località");

    Document html = parser.parse(risposta.data);

    List<Element> dati = html.querySelectorAll(".tableFermateOrari");

    Element tabellaNomi = dati[0];

    List<String> nomi = new List<String>();
    tabellaNomi.nodes[0].nodes.forEach((riga) {
      if (riga.text.trim() != "") nomi.add(riga.text);
    });

    Element tabellaOrari = dati[1];

    List<Localita> localita = [];

    for (int i = 0; i < nomi.length; i++) {
      List<Orario> orari = [];

      tabellaOrari.querySelectorAll("tr:nth-child(${i + 1}) > td").forEach((element) {
        if (element.text.trim() != "") orari.add(Orario.fromString(element.text));
      });

      localita.add(Localita(nome: nomi[i], orari: orari));
    }

    await Hive.box("cache").put("localita-$idLinea-$direzione", localita);

    yield localita;
  }
}
