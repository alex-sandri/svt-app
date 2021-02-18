import 'package:flutter/material.dart';
import 'package:svt_app/models/Visualizzabile.dart';
import 'package:hive/hive.dart';

part 'Linea.g.dart';

@HiveType(typeId: 0)
class Linea implements Visualizzabile {
  @HiveField(0)
  final int direzione;

  @HiveField(1)
  final String codice;

  @HiveField(2)
  final String destinazioneAndata;

  @HiveField(3)
  final String destinazioneRitorno;

  @HiveField(4)
  final String descrizione;

  const Linea({
    @required this.direzione,
    @required this.codice,
    @required this.destinazioneAndata,
    @required this.destinazioneRitorno,
    @required this.descrizione,
  });

  Linea.fromJson(Map<String, dynamic> json)
      : this(
          direzione: int.parse(json["Direzione"]),
          codice: json["CodLineaUtenza"],
          destinazioneAndata: json["DestinazioneAndata"],
          destinazioneRitorno: json["DestinazioneRitorno"],
          descrizione: json["Descrizione"],
        );

  @override
  Widget get sottotitlo => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            destinazioneAndata,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            destinazioneRitorno,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );

  @override
  Widget get titolo => Text(codice);
}
