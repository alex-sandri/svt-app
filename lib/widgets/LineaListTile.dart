import 'package:flutter/material.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/routes/LocalitaView.dart';

class LineaListTile extends StatelessWidget {
  final Linea linea;

  LineaListTile(this.linea);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: linea.titolo,
      subtitle: linea.sottotitlo,
      isThreeLine: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocalitaView(linea),
          ),
        );
      },
    );
  }
}