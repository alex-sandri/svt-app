import 'package:svt_app/models/Preferito.dart';
import 'package:hive/hive.dart';

class GestorePreferiti {
  List<Preferito> _preferiti;

  GestorePreferiti() {
    _preferiti = new List();
  }

  Future<void> _aggiornaCache() async {
    await Hive.box("preferiti").put("soluzioni", _preferiti);
  }

  void aggiungiPreferito(Preferito preferito) async {
    if (!_preferiti.contains(preferito)) {
      _preferiti.add(preferito);
      await _aggiornaCache();
    }
  }

  Future<bool> rimuoviPreferito(Preferito preferito) async {
    bool rimosso = _preferiti.remove(preferito);
    if (rimosso) await _aggiornaCache();

    return rimosso;
  }

  Future<void> rimuoviPreferitoAt(int index) async {
    _preferiti.removeAt(index);
    await _aggiornaCache();
  }

  Future<void> ripristinaPreferiti() async {
    _preferiti = (await Hive.box("preferiti").get("soluzioni") as List)?.whereType<Preferito>()?.toList() ?? [];
  }

  Preferito operator [](int index) => _preferiti[index];

  int get quantita => this._preferiti.length;
}
