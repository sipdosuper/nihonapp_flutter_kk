import 'package:duandemo/themes/appbar_theme.dart';
import 'package:duandemo/themes/color_scheme.dart';
import 'package:duandemo/themes/drawer_theme.dart';
import 'package:duandemo/themes/elevated_button_theme.dart';
import 'package:duandemo/themes/outlined_button_theme.dart';
import 'package:duandemo/themes/text_theme.dart';
import 'package:flutter/material.dart';

class FAppTheme {
  FAppTheme._();

  static ThemeData lightTheme = ThemeData(
    appBarTheme: FAppBarTheme.lightTheme,
    drawerTheme: FDrawerTheme.lightTheme,
    colorScheme: FColorScheme.lightTheme,
    textTheme: FTextTheme.lightTheme,
    elevatedButtonTheme: FElevatedButtonTheme.lightTheme,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 182, 212, 228), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(7),
      labelStyle: FTextTheme.lightTheme.bodyMedium?.copyWith(
        color: Colors.grey[600],
      ),
      outlineBorder: const BorderSide(color: Colors.blueGrey, width: 2),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF003049),
      foregroundColor: Colors.white,
    ),
    outlinedButtonTheme: FOutlinedButtonTheme.lightTheme,
    popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData.dark(useMaterial3: true);
}
