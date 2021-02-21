import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/widgets/Loading.dart';
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
    print(fermate);
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: StreamBuilder(
          stream: Api.ottieniLocalita(linea.codice, linea.direzione),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();
            List<Localita> localita = snapshot.data;

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
                  itemBuilder: (context, index) => localita[index].toWidget(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
