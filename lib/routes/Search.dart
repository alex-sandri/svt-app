import 'package:flutter/material.dart';
import 'package:svt_app/models/Api.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/routes/Linee.dart';
import 'package:svt_app/routes/Soluzioni.dart';
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
  String _errorePartenzaDropdown;

  String _erroreDestinazione;
  String _erroreDestinazioneDropdown;

  List<SearchResult> _partenze = [];
  List<SearchResult> _destinazioni = [];

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

                    if (_partenze.isNotEmpty)
                      SizedBox(height: 10),

                    if (_partenze.isNotEmpty)
                      DropdownButtonFormField<SearchResult>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Seleziona una partenza",
                          errorText: _errorePartenzaDropdown,
                        ),
                        items: _partenze.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.descrizione,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          setState(() { _partenzaSelezionata = selected; });
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

                    if (_destinazioni.isNotEmpty)
                      SizedBox(height: 10),

                    if (_destinazioni.isNotEmpty)
                      DropdownButtonFormField<SearchResult>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Seleziona una destinazione",
                          errorText: _erroreDestinazioneDropdown,
                        ),
                        items: _destinazioni.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.descrizione,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          setState(() { _destinazioneSelezionata = selected; });
                        },
                      ),

                    SizedBox(height: 30),

                    if (_isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ CircularProgressIndicator() ],
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
                              _errorePartenza
                                = _errorePartenzaDropdown
                                = _erroreDestinazione
                                = _erroreDestinazioneDropdown
                                = null;
                            });

                            if (partenza.isEmpty)
                            {
                              _errorePartenza = "La partenza non può essere vuota";
                            }

                            if (_partenzaSelezionata == null)
                            {
                              _errorePartenzaDropdown = "Seleziona una partenza";
                            }

                            if (destinazione.isEmpty)
                            {
                              _erroreDestinazione = "La destinazione non può essere vuota";
                            }

                            if (_destinazioneSelezionata == null)
                            {
                              _erroreDestinazioneDropdown = "Seleziona una destinazione";
                            }

                            if
                            (
                              partenza.isEmpty
                              || _partenzaSelezionata == null
                              || destinazione.isEmpty
                              || _destinazioneSelezionata == null
                            )
                            {
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
