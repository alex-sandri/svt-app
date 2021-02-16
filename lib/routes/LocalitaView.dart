import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/widgets/Loading.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class LocalitaView extends StatelessWidget {
  final Linea _linea;

  LocalitaView(this._linea);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    "Linea: ${_linea.codice}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: StreamBuilder(
          stream: Api.ottieniLocalita(_linea.codice, _linea.direzione),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();
            List<Localita> localita = snapshot.data;

            return ListView.builder(
              itemCount: localita.length,
              itemBuilder: (context, index) => localita[index].toWidget(),
            );
          },
        ),
      ),
    );
  }
}
