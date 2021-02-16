import 'package:flutter/material.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _isLoading = false;

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
                    decoration: InputDecoration(
                      labelText: "Partenza",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Destinazione",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),

                  if (_isLoading)
                    CircularProgressIndicator(),

                  if (!_isLoading)
                    Container(
                      width: double.infinity,
                      child: TextButton.icon(
                        icon: Icon(Icons.search),
                        label: Text("Cerca"),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

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
