import 'dart:async';

import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/routes/Linee.dart';
import 'package:svt_app/routes/Soluzioni.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _isLoading = false;

  final Duration delay = Duration(seconds: 1);

  TextEditingController _partenzaController = TextEditingController();
  TextEditingController _destinazioneController = TextEditingController();

  String _errorePartenza;
  String _errorePartenzaDropdown;

  String _erroreDestinazione;
  String _erroreDestinazioneDropdown;

  List<SearchResult> _partenze = [];
  List<SearchResult> _destinazioni = [];

  SearchResult _partenzaSelezionata;
  SearchResult _destinazioneSelezionata;

  Timer _timerDestinazione, _timerPartenza;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              tooltip: "Linee",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Linee(),
                  ),
                );
              },
            ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cerca soluzioni di viaggio",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    TypeAheadFormField<SearchResult>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _partenzaController,
                        decoration: InputDecoration(
                          labelText: "Partenza",
                          errorText: _errorePartenza,
                        ),
                      ),
                      itemBuilder: (context, item) {
                        return Text(item.descrizione);
                      },
                      onSuggestionSelected: (suggestion) {
                        print(suggestion);
                      },
                      suggestionsCallback: Api.ricerca,
                    ),
                    SizedBox(height: 20),
                    TypeAheadFormField<SearchResult>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _destinazioneController,
                        decoration: InputDecoration(
                          labelText: "Destinazione",
                          errorText: _erroreDestinazione,
                        ),
                      ),
                      itemBuilder: (context, item) {
                        return Text(item.descrizione);
                      },
                      onSuggestionSelected: (suggestion) {
                        print(suggestion);
                      },
                      suggestionsCallback: Api.ricerca,
                    ),
                    SizedBox(height: 30),
                    if (_isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ),
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
                              _errorePartenza = _errorePartenzaDropdown = _erroreDestinazione = _erroreDestinazioneDropdown = null;
                            });

                            if (partenza.isEmpty) {
                              _errorePartenza = "La partenza non può essere vuota";
                            }

                            if (_partenzaSelezionata == null) {
                              _errorePartenzaDropdown = "Seleziona una partenza";
                            }

                            if (destinazione.isEmpty) {
                              _erroreDestinazione = "La destinazione non può essere vuota";
                            }

                            if (_destinazioneSelezionata == null) {
                              _erroreDestinazioneDropdown = "Seleziona una destinazione";
                            }

                            if (partenza.isEmpty || _partenzaSelezionata == null || destinazione.isEmpty || _destinazioneSelezionata == null) {
                              setState(() {});

                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            final soluzioni = await Api.cercaSoluzioniDiViaggio(_partenzaSelezionata, _destinazioneSelezionata);

                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Soluzioni(soluzioni),
                            ));
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
