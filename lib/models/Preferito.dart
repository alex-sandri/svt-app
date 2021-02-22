import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:svt_app/models/SearchResult.dart';

part 'Preferito.g.dart';

@HiveType(typeId: 3)
class Preferito {
  @HiveField(0)
  String _nome;

  @HiveField(1)
  final SearchResult partenza;

  @HiveField(2)
  final SearchResult destinazione;

  Preferito(this._nome, {
    @required this.partenza,
    @required this.destinazione,
  });

  Preferito.create(String nome, {
    @required this.partenza,
    @required this.destinazione,
  })
  {
    this.nome = nome;
  }

  get nome => _nome;
  set nome(String nome) {
    nome = nome.trim();

    if (nome.isEmpty)
    {
      throw Exception("Il nome non può essere vuoto");
    }

    _nome = nome;
  }

  bool operator ==(other) => other._nome == this._nome;
}
