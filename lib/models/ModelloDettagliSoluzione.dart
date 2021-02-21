import 'package:flutter/material.dart';

class ModelloDettagliSoluzione
{
  final List<String> indicazioni;

  // Fermate per ciascuna tratta
  final List<List<String>> fermate;

  ModelloDettagliSoluzione({
    @required this.indicazioni,
    @required this.fermate,
  });
}