import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Coordinate.dart';

part 'SearchResult.g.dart';

@HiveType(typeId: 4)
class SearchResult
{
  @HiveField(0)
  final SearchResultType tipo;

  @HiveField(1)
  final String nome;

  @HiveField(2)
  final String descrizione;

  @HiveField(3)
  final String comune;

  @HiveField(4)
  final String indirizzo;

  @HiveField(5)
  final String comuneIstat;

  @HiveField(6)
  final String idVia;

  @HiveField(7)
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
      return Api.fromEpsg32632ToEpsg4326(coordinate);
    }

    return Api.ottieniCoordinate(comuneIstat, idVia);
  }

  Widget toWidget() {
    return ListTile(
      leading: Icon(
        tipo == SearchResultType.FERMATA
          ? Icons.directions_bus_rounded
          : (
            tipo == SearchResultType.INDIRIZZO
              ? Icons.home
              : Icons.place
          ),
      ),
      title: Text(descrizione),
    );
  }
}

@HiveType(typeId: 5)
enum SearchResultType
{
  @HiveField(0)
  LOCALITA,

  @HiveField(1)
  INDIRIZZO,

  @HiveField(2)
  FERMATA,
}
