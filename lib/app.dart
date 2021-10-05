import 'package:sydoo/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Sydoo',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', '')
      ],
      home: SplashScreen()
    );
  }
}

final appTheme = ThemeData(
  primaryColor: const Color(0xff0269AD),
  primaryColorDark: const Color(0xff015D9A),
  backgroundColor: const Color(0xffF7F9FA),
  textSelectionColor: const Color(0xff808080),
);
