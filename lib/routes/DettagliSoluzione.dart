import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/models/Preferito.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';
import 'package:svt_app/models/Status.dart';
import 'package:svt_app/routes/AggiungiPreferito.dart';
import 'package:svt_app/routes/LocalitaView.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class DettagliSoluzione extends StatelessWidget {
  final SoluzioneDiViaggio soluzione;
  final GestorePreferiti gestorePreferiti = Status.gestorePreferiti;

  DettagliSoluzione(this.soluzione);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        floatingActionButton: FloatingActionButton(
          tooltip: "Aggiungi ai Preferiti",
          child: Icon(
            Icons.star,
            size: 30,
          ),
          onPressed: () async {
            Preferito p = await showModalBottomSheet(context: context, builder: (context) => AggiungiPreferito(soluzione)) as Preferito;
            if (p != null) gestorePreferiti.aggiungiPreferito(p);
          },
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Dettaglio soluzione",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.trip_origin),
              title: Text(DateFormat.Hm().format(soluzione.oraPartenza)),
              subtitle: Text(soluzione.localitaSalita),
            ),
            ListTile(
              leading: Icon(Icons.place),
              title: Text(DateFormat.Hm().format(soluzione.oraArrivo)),
              subtitle: Text(soluzione.localitaDiscesa),
            ),
            ListTile(
              isThreeLine: true,
              leading: Icon(Icons.schedule),
              title: Text("${soluzione.minutiTotali} minuti"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${soluzione.minutiPiedi} a piedi"),
                  Text("${soluzione.minutiBordo} a bordo"),
                ],
              ),
            ),
            ListTile(
              isThreeLine: true,
              leading: Icon(Icons.directions_walk),
              title: Text("${soluzione.metriTotali} metri"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${soluzione.metriPiedi} a piedi"),
                  Text("${soluzione.metriBordo} a bordo"),
                ],
              ),
            ),
            ExpansionTile(
              leading: Icon(Icons.directions_bus),
              title: Text("Tratte"),
              children: soluzione.tratte.map((tratta) {
                return ListTile(
                  title: tratta.titolo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocalitaView(tratta),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            FutureBuilder<List<String>>(
              future: Api.ottieniIndicazioniSoluzione(soluzione),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                {
                  return Container();
                }

                return ExpansionTile(
                  leading: Icon(Icons.directions),
                  title: Text("Indicazioni"),
                  children: snapshot.data.map((indicazione) {
                    return ListTile(
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.circle),
                          Text(
                            "${snapshot.data.indexOf(indicazione) + 1}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      title: Text(indicazione),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
