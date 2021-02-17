import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
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

    final List<SearchResult> items = (response.data as List).map((item) => SearchResult.fromJson(item)).toList();

    return items;
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
