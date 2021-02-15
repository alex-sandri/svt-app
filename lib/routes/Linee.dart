import 'package:flutter/material.dart';
import 'package:svt_app/miscellaneous/SvtSearchDelegate.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/routes/Localit%C3%A0.dart';

class Linee extends StatelessWidget {
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
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              tooltip: "Cerca",
              onPressed: () => showSearch(
                context: context,
                delegate: SvtSearchDelegate<Linea>(
                  future: (query) => Api.ottieniLinee(query: query),
                  builder: (linea) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocalitaView(linea),
                          ));
                    },
                    title: linea.titolo,
                    subtitle: linea.sottotitlo,
                  ),

                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder<List<Linea>>(
          stream: Api.ottieniLinee(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => ListTile(
                title: snapshot.data[index].titolo,
                subtitle: snapshot.data[index].sottotitlo,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocalitaView(snapshot.data[index]),
                      ));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
