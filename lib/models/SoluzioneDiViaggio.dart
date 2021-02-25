import 'package:flutter/material.dart';
import 'package:svt_app/models/Linea.dart';

class SoluzioneDiViaggio {
  final String contesto;
  final int indice;

  final String localitaSalita;
  final String localitaDiscesa;

  final DateTime oraPartenza;
  final DateTime oraArrivo;

  final int metriBordo;
  final int metriPiedi;
  final int metriTotali;

  final int minutiBordo;
  final int minutiPiedi;
  final int minutiTotali;

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

  SoluzioneDiViaggio.fromJson(Map<String, dynamic> json, String contesto): this(
    contesto: contesto,
    indice: json["Numero"],
    localitaSalita: json["LocalitaSalita"],
    localitaDiscesa: json["LocalitaDiscesa"],
    oraPartenza: DateTime.fromMillisecondsSinceEpoch(
      int.parse(
        (json["DataOraPartenza"] as String).replaceFirst("/Date(", "").replaceFirst(")/", ""),
      ),
    ).toUtc().add(Duration(hours: 1)),
    oraArrivo: DateTime.fromMillisecondsSinceEpoch(
      int.parse(
        (json["DataOraArrivo"] as String).replaceFirst("/Date(", "").replaceFirst(")/", ""),
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
