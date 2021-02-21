import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/routes/GestionePreferiti.dart';
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

  TextEditingController _partenzaController = TextEditingController();
  TextEditingController _destinazioneController = TextEditingController();

  String _errorePartenza;

  String _erroreDestinazione;

  SearchResult _partenzaSelezionata;
  SearchResult _destinazioneSelezionata;

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
                      keepSuggestionsOnLoading: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _partenzaController,
                        decoration: InputDecoration(
                          labelText: "Partenza",
                          errorText: _errorePartenza,
                        ),
                      ),
                      itemBuilder: (context, item) => item.toWidget(),
                      onSuggestionSelected: (suggestion) {
                        _partenzaController.text = suggestion.nome;
                        _partenzaSelezionata = suggestion;
                      },
                      suggestionsCallback: Api.ricerca,
                      noItemsFoundBuilder: (context) {
                        return ListTile(
                          leading: Icon(Icons.clear),
                          title: Text("Nessun risultato"),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TypeAheadFormField<SearchResult>(
                      keepSuggestionsOnLoading: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _destinazioneController,
                        decoration: InputDecoration(
                          labelText: "Destinazione",
                          errorText: _erroreDestinazione,
                        ),
                      ),
                      itemBuilder: (context, item) => item.toWidget(),
                      onSuggestionSelected: (suggestion) {
                        _destinazioneController.text = suggestion.nome;
                        _destinazioneSelezionata = suggestion;
                      },
                      suggestionsCallback: Api.ricerca,
                      noItemsFoundBuilder: (context) {
                        return ListTile(
                          leading: Icon(Icons.clear),
                          title: Text("Nessun risultato"),
                        );
                      },
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
                          onPressed: () {
                            setState(() {
                              _errorePartenza = _partenzaSelezionata == null ? "Seleziona la partenza" : null;
                              _erroreDestinazione = _destinazioneSelezionata == null
                                ? "Seleziona la destinazione"
                                : (
                                    _partenzaSelezionata.nome == _destinazioneSelezionata.nome
                                    ? "La destinazione deve essere diversa dalla partenza"
                                    : null
                                );
                            });

                            if (_errorePartenza == null && _erroreDestinazione == null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Soluzioni(
                                  partenza: _partenzaSelezionata,
                                  destinazione: _destinazioneSelezionata,
                                ),
                              ));
                            }
                          },
                        ),
                      ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Preferiti",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.settings),
                          label: Text("Gestisci"),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GestionePreferiti()
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 150,
                      child: Consumer<GestorePreferiti>(
                        builder: (context, gestorePreferiti, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: gestorePreferiti.quantita <= 5
                              ? (
                                  gestorePreferiti.quantita > 0
                                    ? gestorePreferiti.quantita
                                    : 1
                                )
                              : 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (gestorePreferiti.quantita == 0)
                              {
                                return Text("Non hai ancora aggiunto nulla ai preferiti");
                              }

                              final preferito = gestorePreferiti[index];

                              return preferito.toWidget(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Soluzioni(
                                      partenza: preferito.partenza,
                                      destinazione: preferito.destinazione,
                                    ),
                                  ));
                                },
                              );
                            },
                          );
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
