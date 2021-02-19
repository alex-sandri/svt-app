import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:svt_app/models/Linea.dart';

part 'SoluzioneDiViaggio.g.dart';

@HiveType(typeId: 4)
class SoluzioneDiViaggio {
  
  @HiveField(0)
  final String localitaSalita;
  @HiveField(1)
  final String localitaDiscesa;

  @HiveField(2)
  final DateTime oraPartenza;
  @HiveField(3)
  final DateTime oraArrivo;

  @HiveField(4)
  final int metriBordo;
  @HiveField(6)
  final int metriPiedi;
  @HiveField(7)
  final int metriTotali;

  @HiveField(8)
  final int minutiBordo;
  @HiveField(9)
  final int minutiPiedi;
  @HiveField(10)
  final int minutiTotali;

  @HiveField(11)
  final List<Linea> tratte;

  SoluzioneDiViaggio({
    @required this.contesto,
    @required this.indice,
    @required this.localitaSalita,
    @required this.localitaDiscesa,
    @required this.oraPartenza,
    @required this.oraArrivo,
    @required this.metriBordo,
    @required this.metriPiedi,
    @required this.metriTotali,
    @required this.minutiBordo,
    @required this.minutiPiedi,
    @required this.minutiTotali,
    @required this.tratte,
  });


  SoluzioneDiViaggio.fromJson(Map<String, dynamic> json, String contesto, int indice): this(
    contesto: contesto,
    indice: indice,
    localitaSalita: json["LocalitaSalita"],
    localitaDiscesa: json["LocalitaDiscesa"],
    oraPartenza: DateTime.fromMillisecondsSinceEpoch(
      int.parse(
        (json["DataOraPartenza"] as String)
          .replaceFirst("/Date(", "")
          .replaceFirst(")/", ""),
      ),
    ).toUtc().add(Duration(hours: 1)),
    oraArrivo: DateTime.fromMillisecondsSinceEpoch(
      int.parse(
        (json["DataOraArrivo"] as String)
          .replaceFirst("/Date(", "")
          .replaceFirst(")/", ""),
      ),
    ).toUtc().add(Duration(hours: 1)),
    metriBordo: json["MetriBordo"],
    metriPiedi: json["MetriPiedi"],
    metriTotali: json["MetriTotali"],
    minutiBordo: json["MinutiBordo"],
    minutiPiedi: json["MinutiPiedi"],
    minutiTotali: json["MinutiTotali"],
    tratte: (json["Tratte"] as List).map((tratta) {
      return Linea.fromJson(tratta["Linea"]);
    }).toList(),
  );
}
