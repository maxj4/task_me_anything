import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final themes = [
  _darkPurpleTheme,
  _lightPurpleTheme,
];

final ThemeData _lightPurpleTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFFBB86FC),
    onPrimary: Colors.white,
    secondary: const Color(0xFFFFD54F),
    onSecondary: Colors.black,
    tertiary: const Color(0xFFBB86FC),
    onTertiary: Colors.white,
    error: const Color(0xFFD32F2F),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceTint: const Color(0xFFBB86FC),
    surfaceContainerHighest: const Color(0xFFF8F0FF),
    onSurfaceVariant: Colors.black,
    outline: const Color(0xFFBB86FC),
    scrim: Colors.black.withOpacity(0.5),
    inverseSurface: Colors.black,
    onInverseSurface: Colors.white,
    inversePrimary: const Color(0xFFFFD54F),
    shadow: Colors.black.withOpacity(0.2),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.oswald(
      fontSize: 72,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
    ),
    headlineLarge: GoogleFonts.oswald(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.oswald(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
    ),
    headlineSmall: GoogleFonts.merriweather(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
    ),
    titleLarge: GoogleFonts.merriweather(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.merriweather(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    ),
    bodyLarge: GoogleFonts.merriweather(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.merriweather(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ),
    labelLarge: GoogleFonts.merriweather(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.25,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFFBB86FC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFBB86FC),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFF6D27FF),
        width: 2,
      ),
    ),
  ),
);

final ThemeData _darkPurpleTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBB86FC),
    onPrimary: Colors.black,
    secondary: Color(0xFFFFD54F),
    onSecondary: Colors.black,
    tertiary: Color(0xFFBB86FC),
    onTertiary: Colors.black,
    error: Color(0xFFCF6679),
    onError: Colors.black,
    surface: Color(0xFF4E4B6A),
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF3F3B58),
    onSurfaceVariant: Colors.white,
    outline: Color(0xFFBB86FC),
    surfaceTint: Color(0xFFBB86FC),
    scrim: Colors.black,
    inverseSurface: Colors.white,
    onInverseSurface: Colors.black,
    inversePrimary: Color(0xFFFFD54F),
    shadow: Colors.black,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.oswald(
      fontSize: 72,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
      color: Colors.white,
    ),
    headlineLarge: GoogleFonts.oswald(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.oswald(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      color: Colors.white,
    ),
    headlineSmall: GoogleFonts.merriweather(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.merriweather(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.merriweather(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.merriweather(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.merriweather(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
      color: Colors.white,
    ),
    labelLarge: GoogleFonts.merriweather(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.25,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: const Color(0xFFBB86FC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFBB86FC),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFFFD54F),
        width: 2,
      ),
    ),
  ),
);
