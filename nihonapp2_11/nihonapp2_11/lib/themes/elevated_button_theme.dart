import 'package:flutter/material.dart';

class FElevatedButtonTheme {
  FElevatedButtonTheme._();

  static ElevatedButtonThemeData lightTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(color: Colors.white),
      backgroundColor: const Color(0xFF003049),
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey,
      elevation: 0,
    ),
  );
}
