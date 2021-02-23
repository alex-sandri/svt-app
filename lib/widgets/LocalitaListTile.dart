import 'package:flutter/material.dart';
import 'package:svt_app/models/Localita.dart';

class LocalitaListTile extends StatelessWidget {
  final Localita localita;

  LocalitaListTile(this.localita);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(localita.nome),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Wrap(
            spacing: 30,
            runSpacing: 10,
            children: localita.orari
              .where((orario) => orario.isValid())
              .map((orario) {
                return Text(
                  orario.toString(),
                  style: TextStyle(fontSize: 20),
                );
              })
              .toList(),
          ),
        ),
      ],
    );
  }
}