import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/widgets/Loading.dart';

class LocalitaView extends StatelessWidget {
  final Linea _linea;

  LocalitaView(this._linea);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/svt.png",
              width: 100,
            ),
            Text(
              "Linea: " + _linea.codice,
              style: TextStyle(color: Colors.black),
            )
          ],
        )),
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
