import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/routes/Soluzioni.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';
import 'package:svt_app/models/Status.dart';

class GestionePreferiti extends StatefulWidget {
  @override
  _GestionePreferitiState createState() => _GestionePreferitiState();
}

class _GestionePreferitiState extends State<GestionePreferiti> {
  final GestorePreferiti _gestionePreferiti = Status.gestorePreferiti;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SvtAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "I tuoi Preferiti",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _gestionePreferiti.quantita > 0
              ? _gestionePreferiti.quantita
              : 1,
            itemBuilder: (context, index) {
              if (_gestionePreferiti.quantita == 0)
              {
                return ListTile(
                  title: Text("Non hai ancora aggiunto nulla ai preferiti"),
                );
              }

              final preferito = _gestionePreferiti[index];

              return Dismissible(
                key: Key(preferito.toString()),
                background: Container(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  final String nome = preferito.nome;

                  await _gestionePreferiti.rimuoviPreferito(preferito);

                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Preferito '$nome' eliminato")));

                  setState(() {});
                },
                child: ListTile(
                  onTap: () async {
                    final soluzioni = await Api.cercaSoluzioniDiViaggio(preferito.partenza, preferito.destinazione);

                    await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Soluzioni(soluzioni)
                    ));

                    setState(() {});
                  },
                  title: Text(
                    preferito.nome,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.trip_origin),
                          Text(preferito.partenza.nome, maxLines: 1, overflow: TextOverflow.ellipsis)
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Icon(Icons.place),
                          Text(preferito.destinazione.nome, maxLines: 1, overflow: TextOverflow.ellipsis)
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
