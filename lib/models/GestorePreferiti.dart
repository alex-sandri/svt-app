import 'package:flutter/material.dart';
import 'package:svt_app/models/Preferito.dart';
import 'package:hive/hive.dart';
import 'package:svt_app/models/SearchResult.dart';

class GestorePreferiti extends ChangeNotifier {
  List<Preferito> _preferiti;

  GestorePreferiti() {
    _preferiti = (Hive.box("preferiti").get("soluzioni", defaultValue: []) as List)?.whereType<Preferito>()?.toList();
  }

  Future<void> _aggiornaCache() async {
    await Hive.box("preferiti").put("soluzioni", _preferiti);

    notifyListeners();
  }

  void aggiungiPreferito(Preferito preferito) async {
    if (!_preferiti.contains(preferito)) {
      _preferiti.add(preferito);
      await _aggiornaCache();
    } else
      throw new Exception("nome o percorso gia salvati");
  }

  Future<bool> rimuoviPreferito(Preferito preferito) async {
    bool rimosso = _preferiti.remove(preferito);
    if (rimosso) await _aggiornaCache();

    return rimosso;
  }

  Future<void> rimuoviPreferitoDove({
    @required SearchResult partenza,
    @required SearchResult destinazione,
  }) async {
    _preferiti.removeWhere((preferito) => preferito.partenza == partenza && preferito.destinazione == destinazione);

    await _aggiornaCache();
  }

  bool esistePreferito(SearchResult partenza, SearchResult destinazione) {
    return _preferiti.any((preferito) => preferito.partenza == partenza && preferito.destinazione == destinazione);
  }

  Preferito operator [](int index) => _preferiti[index];

  int get quantita => this._preferiti.length;
}
