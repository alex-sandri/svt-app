import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';

class LocalitaView extends StatelessWidget {
  final Linea _linea;

  LocalitaView(this._linea);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "assets/svt.png",
            height: 50,
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Api.ottieniLocalita(_linea.codice, _linea.direzione),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

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
