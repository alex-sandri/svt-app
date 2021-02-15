import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/models/Orario.dart';
import 'package:svt_app/routes/Linee.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(LineaAdapter()); // 0
  Hive.registerAdapter(OrarioAdapter()); // 1
  Hive.registerAdapter(LocalitaAdapter()); // 2

  await Hive.openBox("cache");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: "SVT",
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.red,
        backgroundColor: Colors.orange,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white,
          actionsIconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("it"),
      ],
      home: Linee(),
    );
  }
}
