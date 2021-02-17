import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _isLoading = false;

  TextEditingController _partenzaController = TextEditingController();
  TextEditingController _destinazioneController = TextEditingController();

  String _errorePartenza;
  String _erroreDestinazione;

  List<SearchResult> _partenze = [];
  List<SearchResult> _destinazioni = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: FocusScope.of(context).unfocus,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _partenzaController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      labelText: "Partenza",
                      errorText: _errorePartenza,
                    ),
                    onFieldSubmitted: (value) async {
                      final result = await Api.ricerca(value);

                      setState(() { _partenze = result; });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    items: _partenze.map((item) {
                      return DropdownMenuItem(
                        child: Text(item.descrizione),
                      );
                    }).toList(),
                    onChanged: (selected) {

                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    controller: _destinazioneController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      labelText: "Destinazione",
                      errorText: _erroreDestinazione,
                    ),
                    onFieldSubmitted: (value) async {
                      final result = await Api.ricerca(value);

                      setState(() { _destinazioni = result; });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    items: _destinazioni.map((item) {
                      return DropdownMenuItem(
                        child: Text(item.descrizione),
                      );
                    }).toList(),
                    onChanged: (selected) {

                    },
                  ),
                  SizedBox(height: 10),

                  if (_isLoading)
                    CircularProgressIndicator(),

                  if (!_isLoading)
                    Container(
                      width: double.infinity,
                      child: TextButton.icon(
                        icon: Icon(Icons.search),
                        label: Text("Cerca"),
                        onPressed: () async {
                          final String partenza = _partenzaController.text;
                          final String destinazione = _destinazioneController.text;

                          setState(() {
                            _errorePartenza = _erroreDestinazione = null;
                          });

                          if (partenza.isEmpty)
                          {
                            _errorePartenza = "La partenza non può essere vuota";
                          }

                          if (destinazione.isEmpty)
                          {
                            _erroreDestinazione = "La destinazione non può essere vuota";
                          }

                          if (partenza.isEmpty || destinazione.isEmpty)
                          {
                            setState(() {});

                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          print(partenza);
                          print(destinazione);

                          await Future.delayed(Duration(seconds: 2));

                          setState(() {
                            _isLoading = false;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
