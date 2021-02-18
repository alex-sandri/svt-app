import 'package:flutter/material.dart';
import 'package:svt_app/models/Preferito.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class AggiungiPreferito extends StatefulWidget {
  final SoluzioneDiViaggio soluzioneDiViaggio;

  AggiungiPreferito(this.soluzioneDiViaggio);
  @override
  _AggiungiPreferitoState createState() => _AggiungiPreferitoState(soluzioneDiViaggio);
}

class _AggiungiPreferitoState extends State<AggiungiPreferito> {
  final SoluzioneDiViaggio soluzioneDiViaggio;
  TextEditingController etNome = TextEditingController();

  _AggiungiPreferitoState(this.soluzioneDiViaggio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SvtAppBar(),
      body: Column(
        children: [
          Text("aggiungi preferito"),
          TextField(
            controller: etNome,
            decoration: InputDecoration(hintText: "Nome"),
          ),
          FlatButton(
              onPressed: () {
                Preferito p = Preferito(etNome.text, soluzioneDiViaggio);
                Navigator.pop(context, p);
              },
              child: Text("aggiungi"))
        ],
      ),
    );
  }
}
