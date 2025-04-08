import 'package:flutter/material.dart';

class FOutlinedButtonTheme {
  FOutlinedButtonTheme._();

  static OutlinedButtonThemeData lightTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF003049),
      side: const BorderSide(
        color: Color(0xFF003049),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
  );
}
