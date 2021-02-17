import 'package:flutter/material.dart';
import 'package:svt_app/models/SoluzioneDiViaggio.dart';
import 'package:svt_app/widgets/SvtAppBar.dart';

class Soluzioni extends StatelessWidget {
  final List<SoluzioneDiViaggio> soluzioni;

  Soluzioni(this.soluzioni);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: SvtAppBar(),
        body: Container(),
      ),
    );
  }
}