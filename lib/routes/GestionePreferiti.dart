import 'package:flutter/material.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/routes/DettagliSoluzione.dart';
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
            itemCount: _gestionePreferiti.quantita,
            itemBuilder: (context, index) => Dismissible(
                key: Key(_gestionePreferiti[index].toString()),
                onDismissed: (direction) async {
                  await _gestionePreferiti.rimuoviPreferito(_gestionePreferiti[index]);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("elemento ${_gestionePreferiti[index].nome} eliminato")));
                },
                child: ListTile(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => DettagliSoluzione(_gestionePreferiti[index].soluzione)));
                    setState(() {});
                  },
                  title: Text(
                    _gestionePreferiti[index].nome,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.trip_origin),
                          Text(_gestionePreferiti[index].soluzione.localitaSalita, maxLines: 1, overflow: TextOverflow.ellipsis)
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Icon(Icons.place),
                          Text(_gestionePreferiti[index].soluzione.localitaDiscesa, maxLines: 1, overflow: TextOverflow.ellipsis)
                        ],
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
