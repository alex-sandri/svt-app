import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/routes/Soluzioni.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class GestionePreferiti extends StatelessWidget {
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
          Consumer<GestorePreferiti>(
            builder: (context, gestorePreferiti, child) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gestorePreferiti.quantita > 0
                  ? gestorePreferiti.quantita
                  : 1,
                itemBuilder: (context, index) {
                  if (gestorePreferiti.quantita == 0)
                  {
                    return ListTile(
                      title: Text("Non hai ancora aggiunto nulla ai preferiti"),
                    );
                  }

                  final preferito = gestorePreferiti[index];

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

                      await Provider.of<GestorePreferiti>(context).rimuoviPreferito(preferito);

                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Preferito '$nome' eliminato")));
                    },
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Soluzioni(
                            partenza: preferito.partenza,
                            destinazione: preferito.destinazione,
                          ),
                        ));
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
              );
            },
          ),
        ],
      ),
    );
  }
}
