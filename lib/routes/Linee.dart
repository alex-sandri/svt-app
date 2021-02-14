import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';

class Linee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Linee"),
        ),
        body: FutureBuilder<List<Linea>>(
          future: Api.ottieniLinee(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
            {
              return LinearProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final Linea linea = snapshot.data[index];

                return ListTile(
                  title: Text(linea.linea.toString()),
                  onTap: () {
                    // TODO
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}