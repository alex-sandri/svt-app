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
    else if (nome.length > 20)
    {
      throw Exception("Il nome deve contenere meno di 20 caratteri");
    }

    _nome = nome;
  }

  bool operator ==(other) => other._nome == this._nome;

  Widget toWidget({Function() onTap}) {
    return Card(
      color: Colors.white,
      child: SizedBox(
        width: 250,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.trip_origin,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(partenza.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(destinazione.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
