import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svt_app/models/Orario.dart';

class Localita {
  String _nome;
  List<Orario> _orari;

  Localita(String nome, List<Orario> orari) {
    this._nome = nome;
    _orari = orari;
  }

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
