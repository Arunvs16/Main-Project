import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade200,
    error: Colors.red,
    surface: Colors.blue,
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.grey.shade800,
        displayColor: Colors.black,
        
      ),
);
