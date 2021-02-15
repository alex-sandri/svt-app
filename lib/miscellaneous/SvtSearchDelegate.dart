import 'package:flutter/material.dart';

class SvtSearchDelegate<T> extends SearchDelegate
{
  final Stream<List<T>> Function(String) stream;

  final Widget Function(T) builder;

  SvtSearchDelegate({
    @required this.stream,
    @required this.builder,
  });
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        tooltip: "Cancella",
        onPressed: () => query = "",
      ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) => BackButton(onPressed: Navigator.of(context).pop);
  
  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
        {
          return Column(
            children: [ LinearProgressIndicator() ],
          );
        }

        final List<T> items = snapshot.data;

        return ListView.builder(
          itemCount: items.isNotEmpty
            ? items.length
            : 1,
          itemBuilder: (context, index) {
            if (items.isEmpty)
              return Text(
                "Nessun risultato",
                textAlign: TextAlign.center,
              );

            final T item = items[index];

            return builder(item);
          },
        );
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) => ListView();
}