import 'package:flutter/material.dart';

class Linea
{
  final int direzione;
  final int linea;
  final String destinazioneAndata;
  final String destinazioneRitorno;
  final String descrizione;

  const Linea({
    @required this.direzione,
    @required this.linea,
    @required this.destinazioneAndata,
    @required this.destinazioneRitorno,
    @required this.descrizione,
  });

  factory Linea.fromJson(Map<String, dynamic> json)
  {
    return Linea(
      direzione: json["Direzione"],
      linea: json["CodLineaUtenza"],
      destinazioneAndata: json["DestinazioneAndata"],
      destinazioneRitorno: json["DestinazioneRitorno"],
      descrizione: json["Descrizione"],
    );
  }
}