import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/theme/colors.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    textTheme: () {
      final baseTextTheme = ThemeData.light().textTheme;
      final commonTextTheme = GoogleFonts.quicksandTextTheme(
        baseTextTheme,
      ).apply(bodyColor: text, displayColor: text);
      return commonTextTheme.copyWith(
        titleLarge: commonTextTheme.titleLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleMedium: commonTextTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: commonTextTheme.titleSmall?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: commonTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: commonTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
    }(),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    textTheme: () {
      final baseTextTheme = ThemeData.dark().textTheme;
      final commonTextTheme = GoogleFonts.quicksandTextTheme(
        baseTextTheme,
      ).apply(bodyColor: textDark, displayColor: textDark);
      return commonTextTheme.copyWith(
        titleLarge: commonTextTheme.titleLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: commonTextTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: commonTextTheme.titleSmall?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: commonTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: commonTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
    }(),
  );
}
