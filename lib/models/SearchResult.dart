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
}

enum SearchResultType
{
  LOCALITA,
  INDIRIZZO,
  FERMATA,
}
