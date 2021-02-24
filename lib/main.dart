import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:svt_app/adapters/TimeOfDayAdapter.dart';
import 'package:svt_app/models/Coordinate.dart';
import 'package:svt_app/models/GestorePreferiti.dart';
import 'package:svt_app/models/Linea.dart';
import 'package:svt_app/models/Localita.dart';
import 'package:svt_app/models/Preferito.dart';
import 'package:svt_app/models/SearchResult.dart';
import 'package:svt_app/routes/Search.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TimeOfDayAdapter());

  Hive.registerAdapter(LineaAdapter()); // 0
  Hive.registerAdapter(LocalitaAdapter()); // 1
  Hive.registerAdapter(PreferitoAdapter()); // 2
  Hive.registerAdapter(SearchResultAdapter()); // 3
  Hive.registerAdapter(SearchResultTypeAdapter()); // 4
  Hive.registerAdapter(CoordinateAdapter()); // 5

  try
  {
    await Hive.openBox("cache");
    await Hive.openBox("preferiti");
  }
  on HiveError
  {
    await Hive.deleteBoxFromDisk("cache");
    await Hive.deleteBoxFromDisk("preferiti");

    await Hive.openBox("cache");
    await Hive.openBox("preferiti");
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => GestorePreferiti(),
      child: MyApp(),
    ),
  );
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
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        cursorColor: Colors.orange,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.red),
            padding: MaterialStateProperty.all(EdgeInsets.all(15)),
            textStyle: MaterialStateProperty.all(TextStyle(
              fontSize: 20,
            )),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red,
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
      home: Search(),
    );
  }
}
