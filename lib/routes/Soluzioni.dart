import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Soluzioni extends StatelessWidget {
  final List<SoluzioneDiViaggio> soluzioni;

  Soluzioni(this.soluzioni);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Soluzioni di viaggio",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                ...soluzioni.map((soluzione) {
                  return ListTile(
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
                          child: Text(soluzione.localitaDiscesa),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.south_east),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}