import 'package:flutter/material.dart';
ThemeData lightTheme = ThemeData(
  fontFamily: 'Kalapurush',
  primaryColor: Colors.green,
  brightness: Brightness.light,
  secondaryHeaderColor: Colors.red,
  dividerColor: const Color(0xff757575),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
  ),
  textTheme: const TextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.grey,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white), colorScheme: ColorScheme(
      primary: Color(0xFF0DA151),
      brightness: Brightness.light,
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.redAccent,
      surface: Colors.grey,
      onSurface: Colors.grey),
);

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  dividerColor: Colors.black54,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  textTheme: const TextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.grey, unselectedItemColor: Colors.white), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(surface: const Color(0xFF212121)),
);