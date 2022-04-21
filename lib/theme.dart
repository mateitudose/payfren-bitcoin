import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PayfrenTheme {
  static TextTheme textTheme = TextTheme(
      headline1: GoogleFonts.outfit(
          fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
      headline2: GoogleFonts.roboto(
          fontSize: 21, fontWeight: FontWeight.w500, color: Colors.white60),
      bodyText1: GoogleFonts.outfit(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white60),
      bodyText2: GoogleFonts.outfit(
          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey));
}
