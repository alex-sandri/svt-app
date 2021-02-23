import 'package:flutter/material.dart';
import 'package:svt_app/models/Orario.dart';

class ModelloDettagliSoluzione
{
  final List<String> indicazioni;

  // Fermate per ciascuna tratta con il relativo orario
  final List<List<MapEntry<String, Orario>>> fermate;

  ModelloDettagliSoluzione({
    @required this.indicazioni,
    @required this.fermate,
  });
}