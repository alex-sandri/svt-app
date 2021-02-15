import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:svt_app/models/Orario.dart';

part 'Localita.g.dart';

@HiveType(typeId: 2)
class Localita {
  @HiveField(0)
  String _nome;

  @HiveField(1)
  List<Orario> _orari;

  Localita({
    @required String nome,
    @required List<Orario> orari,
  });

  String get nome => _nome;

  Orario operator [](int index) => _orari[index];

  @override
  String toString() {
    String orario = "";
    _orari.forEach((element) {
      orario += element.toString() + " ; ";
    });

    return "$_nome;$orario";
  }

  Widget toWidget() {
    return ExpansionTile(title: Text(_nome), children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Wrap(
          spacing: 30,
          runSpacing: 10,
          children: _orari
              .map((e) => Text(
                    e.toString(),
                    style: TextStyle(fontSize: 20),
                  ))
              .toList(),
        ),
      )
    ]);
  }
}
