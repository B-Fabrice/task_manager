import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/colors.dart';

TextTheme appTextTheme(TextTheme commonTextTheme) {
  return commonTextTheme.copyWith(
    titleLarge: commonTextTheme.titleLarge?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: commonTextTheme.titleMedium?.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: commonTextTheme.titleSmall?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: commonTextTheme.bodyLarge?.copyWith(
      fontSize: 21,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: commonTextTheme.bodyMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: commonTextTheme.titleSmall?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );
}

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: background,
  primaryColorDark: darkBackground,
  textTheme: () {
    final baseTextTheme = ThemeData.light().textTheme;
    final commonTextTheme = GoogleFonts.openSansTextTheme(
      baseTextTheme,
    ).apply(bodyColor: text, displayColor: text);
    return appTextTheme(commonTextTheme);
  }(),
  inputDecorationTheme: InputDecorationTheme(
    alignLabelWithHint: true,
    filled: true,
    fillColor: white,
    labelStyle: GoogleFonts.openSans(
      color: secondary,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderInputRadius),
      borderSide: BorderSide(color: secondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderInputRadius),
      borderSide: BorderSide(color: secondary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderInputRadius),
      borderSide: BorderSide(color: red, width: 2),
    ),
  ),
  iconTheme: IconThemeData(color: secondary),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return primary;
      }
      return darkBackground;
    }),
    overlayColor: WidgetStateProperty.all(primary.withValues(alpha: 0.3)),
  ),
  bottomAppBarTheme: BottomAppBarTheme(color: primary),
  cardColor: darkBackground,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBackground,
  primaryColorDark: background,
  textTheme: () {
    final baseTextTheme = ThemeData.dark().textTheme;
    final commonTextTheme = GoogleFonts.openSansTextTheme(
      baseTextTheme,
    ).apply(bodyColor: textDark, displayColor: textDark);
    return appTextTheme(commonTextTheme);
  }(),
  inputDecorationTheme: InputDecorationTheme(
    alignLabelWithHint: true,
    filled: true,
    fillColor: darkBackground,
    labelStyle: GoogleFonts.openSans(
      color: white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderInputRadius),
      borderSide: BorderSide(color: white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderInputRadius),
      borderSide: BorderSide(color: white, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderInputRadius),
      borderSide: BorderSide(color: red, width: 2),
    ),
  ),
  iconTheme: IconThemeData(color: white),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return primary;
      }
      return background;
    }),
    overlayColor: WidgetStateProperty.all(primary.withValues(alpha: 0.3)),
  ),
  bottomAppBarTheme: BottomAppBarTheme(color: grey),
);
