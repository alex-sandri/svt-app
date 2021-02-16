import 'package:flutter/material.dart';
import 'package:svt_app/miscellaneous/SvtSearchDelegate.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/widgets/Loading.dart';
import 'package:svt_app/routes/LocalitaView.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Linee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              tooltip: "Cerca",
              onPressed: () => showSearch(
                context: context,
                delegate: SvtSearchDelegate<SearchResult>(
                  stream: (query) => Api.ricerca(query).asStream(),
                  builder: (linea) => ListTile(
                    // TODO
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
              return Loading();
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => ListTile(
                title: snapshot.data[index].titolo,
                subtitle: snapshot.data[index].sottotitlo,
                isThreeLine: true,
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
