import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Coordinate.dart';

class SearchResult
{
  final SearchResultType tipo;
  final String nome;
  final String descrizione;
  final String comune;
  final String indirizzo;
  final String comuneIstat;
  final String idVia;
  final Coordinate coordinate;

  SearchResult({
    @required this.tipo,
    @required this.nome,
    @required this.descrizione,
    @required this.comune,
    @required this.indirizzo,
    @required this.comuneIstat,
    @required this.idVia,
    @required this.coordinate,
  });

  SearchResult.fromJson(Map<String, dynamic> json): this(
    tipo: json["Tipo"] == "LOCALITA"
      ? SearchResultType.LOCALITA
      : (json["Tipo"] == "INDIRIZZO"
        ? SearchResultType.INDIRIZZO
        : SearchResultType.FERMATA
      ),
    nome: json["Nome"],
    descrizione: json["Descrizione"],
    comune: json["Comune"],
    indirizzo: json["Indirizzo"],
    comuneIstat: json["IstatComune"],
    idVia: json["ViaID"],
    coordinate: Coordinate(
      latitudine: json["Lat"],
      longitudine: json["Lng"],
    ),
  );

  Future<Coordinate> ottieniCoordinate() async {
    if (tipo != SearchResultType.INDIRIZZO)
    {
      return coordinate;
    }

    return Api.ottieniCoordinate(comuneIstat, idVia);
  }
}

enum SearchResultType
{
  LOCALITA,
  INDIRIZZO,
  FERMATA,
}
