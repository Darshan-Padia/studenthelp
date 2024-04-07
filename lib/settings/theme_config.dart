import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    // useMaterial3: true,
    primaryColor: Colors.blue, // Change primary color to blue
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.grey.shade50,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6750a4),
      onPrimary: Color(0xFFffffff),
      primaryContainer: Color(0xFFe9ddff),
      onPrimaryContainer: Color.fromARGB(255, 148, 154, 233),
    ).copyWith(background: Colors.grey.shade50),
  );

  static ThemeData darkTheme = ThemeData(
    // useMaterial3: true,
    primaryColor: Colors.blue, // Change primary color to blue
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Color.fromARGB(255, 0, 0, 0),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFcfbcff),
      onPrimary: Color.fromARGB(255, 30, 75, 114),
      primaryContainer: Color(0xFF4f378a),
      onPrimaryContainer: Color(0xFFe9ddff),
    ),
  );
}
