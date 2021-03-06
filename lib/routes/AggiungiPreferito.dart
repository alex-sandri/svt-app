import 'package:flutter/material.dart';
import 'package:svt_app/models/Preferito.dart';
import 'package:svt_app/models/SearchResult.dart';

class AggiungiPreferito extends StatefulWidget {
  final SearchResult partenza;
  final SearchResult destinazione;

  AggiungiPreferito({
    @required this.partenza,
    @required this.destinazione,
  });

  @override
  _AggiungiPreferitoState createState() => _AggiungiPreferitoState();
}

class _AggiungiPreferitoState extends State<AggiungiPreferito> {
  TextEditingController etNome = TextEditingController();

  String _errore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "Aggiungi preferito",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: etNome,
                decoration: InputDecoration(
                  labelText: "Nome",
                  errorText: _errore
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    try {
                      Preferito p = Preferito.create(
                        etNome.text,
                        partenza: widget.partenza,
                        destinazione: widget.destinazione,
                      );
                      Navigator.pop(context, p);
                    } catch (e) {
                      setState(() {
                        _errore = e.message;
                      });
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("Aggiungi"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
