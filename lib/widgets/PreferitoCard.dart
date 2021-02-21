import 'package:flutter/material.dart';
import 'package:svt_app/models/Preferito.dart';
import 'package:svt_app/routes/Soluzioni.dart';

class PreferitoCard extends StatelessWidget {
  final Preferito preferito;

  PreferitoCard(this.preferito);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SizedBox(
        width: 250,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Soluzioni(
                  partenza: preferito.partenza,
                  destinazione: preferito.destinazione,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  preferito.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.trip_origin,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(preferito.partenza.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(preferito.destinazione.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}