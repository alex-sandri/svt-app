import 'package:flutter/material.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/routes/LocalitaView.dart';

class LineaListTile extends StatelessWidget {
  final Linea linea;

  LineaListTile(this.linea);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(linea.codice),
      subtitle: linea.destinazioneAndata != null && linea.destinazioneRitorno != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                linea.destinazioneAndata,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                linea.destinazioneRitorno,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        : null,
      isThreeLine: linea.destinazioneAndata != null && linea.destinazioneRitorno != null,
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