import 'package:flutter/cupertino.dart';

class Orario {
  final int ora, minuti;

  Orario({@required this.ora, @required this.minuti});

  @override
  String toString() {
    String m = minuti.toString().padLeft(2, '0');
    String o = this.ora.toString().padLeft(2, '0');

    return "$o:$m";
  }

  factory Orario.fromString(String s) {
    List<String> numeri = s.split(":");
    return new Orario(ora: int.parse(numeri[0]), minuti: int.parse(numeri[1]));
  }
}
