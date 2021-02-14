import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/models/Orario.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:svt_app/models/Linea.dart';

class Api
{
  static Future<List<Linea>> ottieniLinee() async
  {
    final result = await http.post("http://www.mobilitaveneto.net/TP/SVT/StampaOrari/GetDatiLineeSelezionate");

    if (result.statusCode != 200)
    {
      throw Exception("Impossibile ottenere le linee");
    }

    final json = jsonDecode(result.body);

    return (json as List<dynamic>).map((linea) => Linea.fromJson(linea)).toList();
  }
  
  static String _fixData(int parametro) => parametro.toString().padLeft(2, '0');

  static Future<List<Localita>> ottieniLocalita(int idLinea, int direzione) async {
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
      nomi.add(riga.text);
    });

    Element tabellaOrari = dati[1];

    List<Localita> localita = [];

    for (int i = 0; i < nomi.length; i++) {
      List<Orario> orari = [];
      tabellaOrari.nodes[0].nodes[i].nodes.forEach((element) {
        if (element.text.trim() != "") orari.add(Orario.fromString(element.text.replaceFirst("&nbsp;", "")));
      });
      localita.add(new Localita(nomi[i], orari));
    }

    return localita;
  }
}
