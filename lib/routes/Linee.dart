import 'package:flutter/material.dart';
import 'package:svt_app/miscellaneous/SvtSearchDelegate.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';

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
                  stream: (query) => Api.ottieniLinee(query: query),
                  builder: (linea) => linea.toWidget(),
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder<List<Linea>>(
          stream: Api.ottieniLinee(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
            {
              return LinearProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => snapshot.data[index].toWidget(),
            );
          },
        ),
      ),
    );
  }
}