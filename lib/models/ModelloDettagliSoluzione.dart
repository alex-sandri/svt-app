import 'package:flutter/material.dart';

class ModelloDettagliSoluzione
{
  final List<String> indicazioni;

  // Fermate per ciascuna tratta con il relativo orario
  final List<List<MapEntry<String, TimeOfDay>>> fermate;

  ModelloDettagliSoluzione({
    @required this.indicazioni,
    @required this.fermate,
  });
}