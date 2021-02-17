import 'package:flutter/material.dart';

class SearchResult
{
  final SearchResultType tipo;
  final String nome;
  final String descrizione;
  final String comune;
  final String indirizzo;

  SearchResult({
    @required this.tipo,
    @required this.nome,
    @required this.descrizione,
    @required this.comune,
    @required this.indirizzo,
  });

  SearchResult.fromJson(Map<String, dynamic> json): this(
    tipo: json["Tipo"] == "LOCALITA"
      ? SearchResultType.LOCALITA
      : (json["Tipo"] == "INDIRIZZO"
        ? SearchResultType.INDIRIZZO
        : SearchResultType.FERMATA
      ),
    nome: json["Nome"],
    descrizione: json["Descrizione"],
    comune: json["Comune"],
    indirizzo: json["Indirizzo"],
  );
}

enum SearchResultType
{
  LOCALITA,
  INDIRIZZO,
  FERMATA,
}
