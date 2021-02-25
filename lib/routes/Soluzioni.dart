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
  List<SoluzioneDiViaggio> _soluzioni;

  TimeOfDay _from = TimeOfDay(
    hour: 0,
    minute: 0,
  );

  Future<void> _load() async {
    final soluzioni = await Api.cercaSoluzioniDiViaggio(
      partenza: widget.partenza,
      destinazione: widget.destinazione,
      from: _from,
    );

    setState(() {
      _soluzioni = soluzioni;
    });
  }

  @override
  void initState() {
    super.initState();

    _load();
  }

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
                  cancelText: "Annulla",
                  confirmText: "Conferma",
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: TextButtonThemeData(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                          ),
                        ),
                      ),
                      child: child,
                    );
                  },
                );

                if (time != null)
                {
                  setState(() {
                    _from = time;
                    _soluzioni = null;
                  });

                  await _load();
                }
              },
            ),
          ],
        ),
        body: _soluzioni == null
          ? Loading()
          : ListView(
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
                  itemCount: _soluzioni.isNotEmpty
                    ? _soluzioni.length
                    : 1,
                  itemBuilder: (context, index) {
                    if (_soluzioni.isEmpty)
                    {
                      return ListTile(
                        title: Text("Nessuna soluzione trovata"),
                      );
                    }

                    final soluzione = _soluzioni[index];

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
