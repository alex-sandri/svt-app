import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/widgets/Loading.dart';
import 'package:svt_app/widgets/LocalitaListTile.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class LocalitaView extends StatelessWidget {
  final Linea linea;

  final List<String> fermate;

  LocalitaView({
    @required this.linea,
    this.fermate,
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
                  itemCount: localita.length,
                  itemBuilder: (context, index) {
                    return LocalitaListTile(
                      localita[index],
                      highlight: (fermate ?? []).contains(localita[index].nome),
                      highlightIndex: (fermate ?? []).indexOf(localita[index].nome),
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
