import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/models/Preferito.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';
import 'package:svt_app/routes/AggiungiPreferito.dart';
import 'package:svt_app/routes/DettagliSoluzione.dart';
import 'package:svt_app/widgets/Loading.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Soluzioni extends StatelessWidget {
  final SearchResult partenza;
  final SearchResult destinazione;

  Soluzioni({
    @required this.partenza,
    @required this.destinazione,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: FutureBuilder<List<SoluzioneDiViaggio>>(
          future: Api.cercaSoluzioniDiViaggio(partenza, destinazione),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
            {
              return Loading();
            }

            final soluzioni = snapshot.data;

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Soluzioni di viaggio",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: soluzioni.isNotEmpty
                    ? soluzioni.length
                    : 1,
                  itemBuilder: (context, index) {
                    if (soluzioni.isEmpty)
                    {
                      return ListTile(
                        title: Text("Nessuna soluzione trovata"),
                      );
                    }

                    final soluzione = soluzioni[index];

                    return ListTile(
                      isThreeLine: true,
                      leading: Icon(Icons.trip_origin),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat.Hm().format(soluzione.oraPartenza)),
                          Text(DateFormat.Hm().format(soluzione.oraArrivo)),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(soluzione.localitaSalita),
                          ),
                          Expanded(
                            child: Text(
                              soluzione.localitaDiscesa,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.place),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DettagliSoluzione(soluzione),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Aggiungi ai Preferiti",
          child: Icon(
            Icons.star,
            size: 30,
          ),
          onPressed: () async {
            final Preferito p = await showModalBottomSheet<Preferito>(
              context: context,
              builder: (context) => AggiungiPreferito(
                partenza: partenza,
                destinazione: destinazione,
              ),
            );

            if (p != null)
            {
              Provider.of<GestorePreferiti>(context, listen: false).aggiungiPreferito(p);
            }
          },
        ),
      ),
    );
  }
}
