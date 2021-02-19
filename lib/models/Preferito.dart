import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';

part 'Preferito.g.dart';

@HiveType(typeId: 3)
class Preferito {
  @HiveField(0)
  String _nome;
  @HiveField(1)
  SoluzioneDiViaggio _soluzione;

  Preferito(this._nome, this._soluzione);

  Preferito.create(String nome, SoluzioneDiViaggio soluzioneDiViaggio) {
    this.nome = nome;
    _soluzione = soluzioneDiViaggio;
  }

  get nome => _nome;
  set nome(String nome) {
    nome = nome.trim();
    if (nome.length <= 20 && nome.isNotEmpty)
      _nome = nome;
    else
      throw Exception("il nome non puo essere vuoto e deve contenere meno di 20 caratteri");
  }

  get soluzione => _soluzione;

  bool operator ==(other) => other._nome == this._nome;

  Widget toWidget({Function() onTap}) => Card(
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
                      Text(_soluzione.localitaSalita, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(_soluzione.localitaDiscesa, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
