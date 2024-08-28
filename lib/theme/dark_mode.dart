import 'package:flutter/material.dart';

ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade800,
    tertiary: Colors.grey.shade900,
    inversePrimary: Colors.grey.shade200,
    error: Colors.red,
    onPrimary: Colors.blue,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.grey.shade300,
        displayColor: Colors.white,
      ),
);
