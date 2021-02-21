import 'package:flutter/material.dart';
import 'package:svt_app/models/Localita.dart';

class LocalitaListTile extends StatelessWidget {
  final Localita localita;

  final bool highlight;
  final int highlightIndex;

  LocalitaListTile(this.localita, {
    this.highlight = false,
    this.highlightIndex,
  }):
    assert((highlight && highlightIndex != null) || !highlight);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: highlight
        ? Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.circle),
              Text(
                "${highlightIndex + 1}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          )
        : null,
      title: Text(localita.nome),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Wrap(
            spacing: 30,
            runSpacing: 10,
            children: localita.orari
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