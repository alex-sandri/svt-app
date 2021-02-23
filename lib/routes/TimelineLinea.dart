import 'package:flutter/material.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Orario.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineLinea extends StatelessWidget {
  final Linea linea;
  final List<MapEntry<String, Orario>> fermate;

  TimelineLinea({
    @required this.linea,
    @required this.fermate,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Linea ${linea.codice}",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...fermate.map((fermata) {
              return TimelineTile(
                isFirst: fermate.indexOf(fermata) == 0,
                isLast: fermate.indexOf(fermata) == fermate.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 15,
                  height: 15,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10
                  ),
                  color: Theme.of(context).accentColor,
                ),
                beforeLineStyle: LineStyle(
                  color: Theme.of(context).accentColor,
                ),
                endChild: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fermata.value.toString(),
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(fermata.key),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}