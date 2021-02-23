import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Orario.g.dart';

@HiveType(typeId: 1)
class Orario {
  @HiveField(0)
  final int ora;

  @HiveField(1)
  final int minuti;

  Orario({
    @required this.ora,
    @required this.minuti,
  });

  @override
  String toString() {
    String m = minuti.toString().padLeft(2, '0');
    String o = this.ora.toString().padLeft(2, '0');

    return "$o:$m";
  }

  bool isValid() {
    return ora != -1 && minuti != -1;
  }

  factory Orario.fromString(String s) {
    if (s.isEmpty)
    {
      return Orario(
        ora: -1,
        minuti: -1,
      );
    }

    List<String> numeri = s.split(":");
    return new Orario(ora: int.parse(numeri[0]), minuti: int.parse(numeri[1]));
  }
}
