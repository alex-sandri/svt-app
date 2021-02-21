import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:svt_app/models/Orario.dart';

part 'Localita.g.dart';

@HiveType(typeId: 2)
class Localita {
  @HiveField(0)
  final String nome;

  @HiveField(1)
  final List<Orario> orari;

  Localita({
    @required this.nome,
    @required this.orari,
  });

  Orario operator [](int index) => orari[index];

  @override
  String toString() {
    String orario = "";
    orari.forEach((element) {
      orario += element.toString() + " ; ";
    });

    return "$nome;$orario";
  }
}
