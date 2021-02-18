import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/widgets/Loading.dart';
import 'package:svt_app/routes/LocalitaView.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Linee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: StreamBuilder<List<Linea>>(
          stream: Api.ottieniLinee(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            }

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Linee",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
