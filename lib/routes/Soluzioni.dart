import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';
import 'package:svt_app/routes/DettagliSoluzione.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Soluzioni extends StatelessWidget {
  final List<SoluzioneDiViaggio> soluzioni;

  Soluzioni(this.soluzioni);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: ListView(
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
                  leading: Icon(Icons.north_east),
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
                  trailing: Icon(Icons.south_east),
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
      ),
    );
  }
}
