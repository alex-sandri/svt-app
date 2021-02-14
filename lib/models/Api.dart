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

    return (json as List<dynamic>).map((linea) => Linea.fromJson(linea));
  }
}