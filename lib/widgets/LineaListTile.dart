import 'package:flutter/material.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/routes/LocalitaView.dart';
import 'package:svt_app/routes/TimelineLinea.dart';

class LineaListTile extends StatelessWidget {
  final Linea linea;

  final List<String> fermate;

  LineaListTile({
    @required this.linea,
    this.fermate,
  });

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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              if (fermate != null)
              {
                return LocalitaView(linea);
              }

              return TimelineLinea(
                linea: linea,
                fermate: fermate,
              );
            }
          ),
        );
      },
    );
  }
}