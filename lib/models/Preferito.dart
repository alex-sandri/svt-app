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
    if (nome.length <= 20 && nome.isNotEmpty)
      _nome = nome;
    else
      throw Exception("il nome non puo essere vuoto e deve contenere meno di 20 caratteri");
  }

  get soluzione => _soluzione;

  bool operator ==(other) {
    return other._nome == this._nome;
  }
}
