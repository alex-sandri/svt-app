import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/widgets/LineaListTile.dart';
import 'package:svt_app/widgets/Loading.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Linee extends StatefulWidget {
  @override
  _LineeState createState() => _LineeState();
}

class _LineeState extends State<Linee> {
  List<Linea> _lineeSnapshot = [];

  List<Linea> linee = [];

  final TextEditingController _searchController = TextEditingController();

  void _search(String value) {
    setState(() {
      linee = _lineeSnapshot.where((linea) =>
        linea.codice.toLowerCase().contains(value.toLowerCase())
        || linea.destinazioneAndata.toLowerCase().contains(value.toLowerCase())
        || linea.destinazioneRitorno.toLowerCase().contains(value.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: FocusScope.of(context).unfocus,
          child: StreamBuilder<List<Linea>>(
            stream: Api.ottieniLinee(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }

              _lineeSnapshot = snapshot.data;

              if (linee.isEmpty)
              {
                linee = _lineeSnapshot;
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                labelText: "Cerca",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                              ),
                              onSubmitted: _search,
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              child: Icon(Icons.search),
                              onPressed: () => _search(_searchController.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: linee.length,
                    itemBuilder: (context, index) => LineaListTile(
                      linea: linee[index]
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
