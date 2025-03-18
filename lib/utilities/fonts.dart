import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static final ThemeData primaryFontLight = ThemeData(
      textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.light().textTheme));

  static final ThemeData primaryFontDark = ThemeData(
      textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.dark().textTheme));
}
