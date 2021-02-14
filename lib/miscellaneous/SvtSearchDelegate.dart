import 'package:flutter/material.dart';

class SvtSearchDelegate<T> extends SearchDelegate
{
  final Future<List<T>> Function(String) future;

  final Widget Function(T) builder;

  SvtSearchDelegate({
    @required this.future,
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
    return FutureBuilder<List<T>>(
      future: future(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        final List<T> items = snapshot.data;

        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
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