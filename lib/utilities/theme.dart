import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
          brightness: Brightness.light,
          textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.light().textTheme),
          primarySwatch: Colors.green
        );

  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.dark().textTheme),
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Colors.green,
        secondary: Colors.red
      ));

  
}
