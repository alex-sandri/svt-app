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
                        _partenzaSelezionata = suggestion;
                      },
                      suggestionsCallback: Api.ricerca,
                      noItemsFoundBuilder: (context) {
                        return Text("Nessun risultato");
                      },
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
                        _destinazioneSelezionata = suggestion;
                      },
                      suggestionsCallback: Api.ricerca,
                      noItemsFoundBuilder: (context) {
                        return Text("Nessun risultato");
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
                          onPressed: () async {
                            setState(() {
                              _errorePartenza = _partenzaSelezionata == null ? "Seleziona la partenza" : null;
                              _erroreDestinazione = _destinazioneSelezionata == null ? "Seleziona la destinazione" : null;
                            });

                            if (_partenzaSelezionata != null && _destinazioneSelezionata != null)
                            {
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
                            }
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
