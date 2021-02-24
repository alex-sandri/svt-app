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

class Soluzioni extends StatefulWidget {
  final SearchResult partenza;
  final SearchResult destinazione;

  Soluzioni({
    @required this.partenza,
    @required this.destinazione,
  });

  @override
  _SoluzioniState createState() => _SoluzioniState();
}

class _SoluzioniState extends State<Soluzioni> {
  TimeOfDay _from = TimeOfDay(
    hour: 0,
    minute: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.multiple_stop),
              tooltip: "Cerca ritorno",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Soluzioni(
                      partenza: widget.destinazione,
                      destinazione: widget.partenza,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              tooltip: "Filtra",
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _from,
                );

                if (time != null)
                {
                  setState(() {
                    _from = time;
                  });
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<List<SoluzioneDiViaggio>>(
          future: Api.cercaSoluzioniDiViaggio(
            partenza: widget.partenza,
            destinazione: widget.destinazione,
            from: _from,
          ),
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
          tooltip: Provider.of<GestorePreferiti>(context).esistePreferito(widget.partenza, widget.destinazione)
            ? "Rimuovi dai Preferiti"
            : "Aggiungi ai Preferiti",
          child: Icon(
            Provider.of<GestorePreferiti>(context).esistePreferito(widget.partenza, widget.destinazione)
              ? Icons.favorite
              : Icons.favorite_border
          ),
          onPressed: () async {
            if (Provider.of<GestorePreferiti>(context, listen: false).esistePreferito(widget.partenza, widget.destinazione))
            {
              await Provider.of<GestorePreferiti>(context, listen: false).rimuoviPreferitoDove(
                partenza: widget.partenza,
                destinazione: widget.destinazione,
              );
            }
            else
            {
              final Preferito p = await showModalBottomSheet<Preferito>(
                context: context,
                builder: (context) => AggiungiPreferito(
                  partenza: widget.partenza,
                  destinazione: widget.destinazione,
                ),
              );

              if (p != null)
              {
                Provider.of<GestorePreferiti>(context, listen: false).aggiungiPreferito(p);
              }
            }
          },
        ),
      ),
    );
  }
}
