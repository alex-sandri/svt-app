import 'package:flutter/material.dart';
import 'package:svt_app/routes/Linee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SVT",
      home: Linee(),
    );
  }
}
