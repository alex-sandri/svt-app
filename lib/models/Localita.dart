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
}
