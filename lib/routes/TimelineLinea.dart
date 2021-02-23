import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/widgets/Loading.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class TimelineLinea extends StatelessWidget {
  final Linea linea;
  final List<String> fermate;
  final DateTime from;

  TimelineLinea({
    @required this.linea,
    @required this.fermate,
    @required this.from,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: StreamBuilder<List<Localita>>(
          stream: Api.ottieniLocalita(linea.codice, linea.direzione),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();

            final localita = snapshot.data;

            final localitaFermate = localita.where((localita) => fermate.contains(
              localita.nome
                .replaceAll("^", "")
            )).toList();

            final timeIndex = localitaFermate[0].orari.indexWhere((orario) =>
              orario.ora == from.hour
              && orario.minuti == from.minute
            );

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Linea ${linea.codice}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: localitaFermate.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(localitaFermate[index].nome),
                        Text(localitaFermate[index].orari[timeIndex].toString()),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}