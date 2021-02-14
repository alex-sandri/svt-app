import 'package:flutter/material.dart';

class Linea
{
  final int direzione;
  final String codice;
  final String destinazioneAndata;
  final String destinazioneRitorno;
  final String descrizione;

  const Linea({
    @required this.direzione,
    @required this.codice,
    @required this.destinazioneAndata,
    @required this.destinazioneRitorno,
    @required this.descrizione,
  });

  Linea.fromJson(Map<String, dynamic> json): this(
    direzione: int.parse(json["Direzione"]),
    codice: json["CodLineaUtenza"],
    destinazioneAndata: json["DestinazioneAndata"],
    destinazioneRitorno: json["DestinazioneRitorno"],
    descrizione: json["Descrizione"],
  );
}