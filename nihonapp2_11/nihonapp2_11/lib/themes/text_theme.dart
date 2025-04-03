import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FTextTheme {
  FTextTheme._();

  static TextTheme lightTheme = TextTheme(
    titleLarge: GoogleFonts.francoisOne(fontSize: 36, color: Colors.black),
    titleMedium: GoogleFonts.francoisOne(fontSize: 24, color: Colors.black),
    titleSmall: GoogleFonts.francoisOne(fontSize: 16, color: Colors.black),
    bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.black),
    bodySmall: GoogleFonts.inter(fontSize: 12, color: Colors.black),
    labelLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black),
  );
}
