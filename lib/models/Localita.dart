import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Localita.g.dart';

@HiveType(typeId: 2)
class Localita {
  @HiveField(0)
  final String nome;

  @HiveField(1)
  final List<TimeOfDay> orari;

  Localita({
    @required this.nome,
    @required this.orari,
  });

  TimeOfDay operator [](int index) => orari[index];
}
