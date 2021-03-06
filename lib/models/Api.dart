import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:svt_app/models/CacheManager.dart';
import 'package:svt_app/models/Coordinate.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/models/ModelloDettagliSoluzione.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';

class Api {
  static Stream<List<Linea>> ottieniLinee() async* {
    yield (CacheManager.get("linee") as List)?.whereType<Linea>()?.toList();

    final response = await Dio().post("http://www.mobilitaveneto.net/TP/SVT/StampaOrari/GetDatiLineeSelezionate");

    if (response.statusCode != 200) {
      throw Exception("Impossibile ottenere le linee");
    }

    final List<Linea> linee = (response.data as List).map((linea) => Linea.fromJson(linea)).toList();

    await CacheManager.set("linee", linee);

    yield linee;
  }

  static Future<List<SearchResult>> ricerca(String query) async {
    final response = await Dio().post("http://www.mobilitaveneto.net/TP/SVT/Search/Search", queryParameters: {
      "page": 1,
      "rows": 15,
      "searchTerm": query,
    });

    final List<SearchResult> items = (response.data["rows"] as List).map((item) => SearchResult.fromJson(item)).toList();

    return items;
  }

  static Future<Coordinate> ottieniCoordinate(String comuneIstat, String idVia) async {
    final response = await Dio().get("http://ro.autobus.it//PlusGeocoderWS/geocoderws.svc/sgc/$comuneIstat/$idVia/");

    return Coordinate(
      latitudine: response.data["Coordinate"]["Latitude"],
      longitudine: response.data["Coordinate"]["Longitude"],
    );
  }

  static Future<Coordinate> fromEpsg32632ToEpsg4326(Coordinate coordinate) async {
    final response = await Dio().get("https://epsg.io/trans?x=${coordinate.longitudine}&y=${coordinate.latitudine}&s_srs=32632&t_srs=4326&format=json");

    return Coordinate(
      latitudine: num.parse(response.data["y"]),
      longitudine: num.parse(response.data["x"]),
    );
  }

  static Future<List<SoluzioneDiViaggio>> cercaSoluzioniDiViaggio({
    @required SearchResult partenza,
    @required SearchResult destinazione,
    @required TimeOfDay from,
  }) async {
    final Coordinate coordinatePartenza = await partenza.ottieniCoordinate();
    final Coordinate coordinateDestinazione = await destinazione.ottieniCoordinate();

    final response = await Dio().post(
      "http://www.mobilitaveneto.net/TP/SVT/Tp/TrovaSoluzioniViaggio",
      data: FormData.fromMap({
        "pLat": coordinatePartenza.latitudine,
        "pLng": coordinatePartenza.longitudine,
        "dLat": coordinateDestinazione.latitudine,
        "dLng": coordinateDestinazione.longitudine,
        "data": DateFormat("dd/MM/yyyy").format(DateTime.now()),
        "ora": "${from.hour.toString().padLeft(2, "0")}:${from.minute.toString().padLeft(2, "0")}",
        "tipoMezzo": -1,
        "tipoSoluzione": 0,
        "jsonTappe": "[]",
      }),
    );

    List<SoluzioneDiViaggio> soluzioni = [];

    for (int i = 0; i < (response.data["solutions"] as List).length; i++)
    {
      soluzioni.add(SoluzioneDiViaggio.fromJson(
        response.data["solutions"][i],
        response.data["contextName"],
      ));
    }

    return soluzioni;
  }

  static Future<ModelloDettagliSoluzione> ottieniIndicazioniSoluzione(SoluzioneDiViaggio soluzione) async {
    final response = await Dio().post(
      "http://www.mobilitaveneto.net/TP/SVT/Tp/GetSolutionDetail",
      data: FormData.fromMap({
        "contesto": soluzione.contesto,
        "numSoluzione": soluzione.indice,
        "tratte": "",
      }),
    );

    final document = parser.parse(response.data);

    final indicazioni = document.querySelectorAll(".action").map((action) {
      return action.text
        .replaceFirst("( Mappa )", "")
        .replaceFirst("( Orario - Mappa )", "")
        .trim();
    }).toList();

    final fermate = document.querySelectorAll(".tableOrario").map((orario) {
      return orario.querySelectorAll(".orarioSelected").map((fermata) {
        final timeText = fermata.children[1].text.trim();

        return MapEntry(
          fermata.children[0].text.trim(),
          TimeOfDay(
            hour: int.parse(timeText.split(".")[0]),
            minute: int.parse(timeText.split(".")[1]),
          ),
        );
      }).toList();
    }).toList();

    return ModelloDettagliSoluzione(
      indicazioni: indicazioni,
      fermate: fermate,
    );
  }

  static Stream<List<Localita>> ottieniLocalita(String idLinea, int direzione) async* {
    yield (CacheManager.get("localita-$idLinea-$direzione") as List)?.whereType<Localita>()?.toList();

    Dio dio = Dio();
    Map<String, dynamic> richiesta = new Map<String, dynamic>();

    richiesta["linea"] = idLinea;
    richiesta["direzione"] = direzione;
    richiesta["di"] = DateFormat("dd/MM/yyyy").format(DateTime.now());
    richiesta["codLineaUtenza"] = idLinea;
    richiesta["vector"] = "SOCIETA VICENTINA TRASPORTI s.r.l.";
    richiesta["codAzienda"] = "SVT";
    FormData formData = FormData.fromMap(richiesta);

    Response risposta = await dio.post("http://www.mobilitaveneto.net/TP/SVT/StampaOrari/GetOrariLinea", data: formData);

    if (risposta.statusCode != 200) throw Exception("impossibile ottenre le località");

    dom.Document html = parser.parse(risposta.data);

    List<dom.Element> dati = html.querySelectorAll(".tableFermateOrari");

    dom.Element tabellaNomi = dati[0];

    List<String> nomi = [];
    tabellaNomi.nodes[0].nodes.forEach((riga) {
      if (riga.text.trim() != "") nomi.add(riga.text.trim());
    });

    dom.Element tabellaOrari = dati[1];

    List<Localita> localita = [];

    for (int i = 0; i < nomi.length; i++) {
      List<TimeOfDay> orari = [];

      tabellaOrari.querySelectorAll("tr:nth-child(${i + 1}) > td").forEach((element) {
        final text = element.text.trim();

        if (text.isNotEmpty)
        {
          orari.add(TimeOfDay(
            hour: int.parse(text.split(":")[0]),
            minute: int.parse(text.split(":")[1]),
          ));
        }
      });

      localita.add(Localita(nome: nomi[i], orari: orari));
    }

    await CacheManager.set("localita-$idLinea-$direzione", localita);

    yield localita;
  }
}
