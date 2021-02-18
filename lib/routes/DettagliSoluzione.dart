import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/models/Preferito.dart';
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
          child: Text("+"),
          onPressed: () async {
            Preferito p = await showDialog(context: context, builder: (context) => AggiungiPreferito(soluzione)) as Preferito;
            if (p != null) gestorePreferiti.aggiungiPreferito(p);
          },
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Text(
              "Dettaglio soluzione",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
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
          ],
        ),
      ),
    );
  }
}
