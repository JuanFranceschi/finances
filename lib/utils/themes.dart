import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const themeColor = Color.fromRGBO(0, 74, 173, 1);
const errorColor = Color.fromARGB(255, 241, 81, 70);

InputDecorationTheme inputTheme(Color primary, Color tertiary) =>
    InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: tertiary),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: themeColor),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: errorColor,
        ),
      ),
    );

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.pridiTextTheme(
    TextTheme(
      titleLarge: GoogleFonts.pridi(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.pridi(fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.pridi(fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.pridi(fontWeight: FontWeight.w400),
      labelMedium: GoogleFonts.pridi(fontWeight: FontWeight.w400),
      labelSmall: GoogleFonts.pridi(fontWeight: FontWeight.w400),
    ),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 248),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 248, 248, 248),
  ),
  hintColor: const Color.fromARGB(255, 188, 192, 199),
  focusColor: themeColor,
  shadowColor: const Color.fromARGB(50, 102, 108, 114),
  colorScheme: const ColorScheme.light(
    primaryContainer: Color.fromARGB(255, 255, 255, 255),
    secondaryContainer: Color.fromARGB(255, 232, 232, 232),
    tertiaryContainer: Color.fromARGB(255, 222, 222, 222),
    primary: Color.fromARGB(255, 41, 46, 51),
    secondary: Color.fromARGB(255, 81, 86, 101),
    tertiary: Color.fromARGB(255, 151, 148, 157),
    shadow: Color.fromARGB(50, 102, 108, 114),
  ),
  inputDecorationTheme: inputTheme(
    const Color.fromARGB(255, 41, 46, 51),
    const Color.fromARGB(255, 151, 148, 157),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 248, 248, 248),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: themeColor,
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.zero,
      minimumSize: const Size(50, 50),
      iconColor: const Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  dataTableTheme: DataTableThemeData(
    headingRowColor: WidgetStateColor.resolveWith((states) {
      return const Color.fromARGB(255, 214, 218, 224);
    }),
    headingTextStyle: const TextStyle(
      color: Color.fromARGB(255, 41, 46, 51),
    ),
    dataTextStyle: const TextStyle(
      color: Color.fromARGB(255, 46, 50, 56),
    ),
    dataRowColor: WidgetStateColor.resolveWith((states) {
      return const Color.fromARGB(255, 230, 232, 238);
    }),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 27, 31, 38),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 27, 31, 38),
  ),
  textTheme: GoogleFonts.pridiTextTheme(
    TextTheme(
      titleLarge: GoogleFonts.pridi(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.pridi(fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.pridi(fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.pridi(fontWeight: FontWeight.w400),
      labelMedium: GoogleFonts.pridi(fontWeight: FontWeight.w400),
      labelSmall: GoogleFonts.pridi(fontWeight: FontWeight.w400),
    ),
  ),
  hintColor: const Color.fromARGB(255, 142, 142, 142),
  focusColor: themeColor,
  shadowColor: const Color.fromARGB(20, 233, 232, 232),
  colorScheme: const ColorScheme.dark(
    primaryContainer: Color.fromARGB(255, 17, 21, 28),
    secondaryContainer: Color.fromARGB(255, 37, 41, 48),
    tertiaryContainer: Color.fromARGB(255, 47, 51, 58),
    primary: Color.fromARGB(255, 254, 254, 254),
    secondary: Color.fromARGB(255, 213, 216, 224),
    tertiary: Color.fromARGB(255, 163, 166, 174),
    shadow: Color.fromARGB(20, 233, 232, 232),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 27, 31, 38),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: themeColor,
      textStyle: const TextStyle(
        color: Color.fromARGB(255, 217, 220, 226),
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: const Size(50, 50),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      iconColor: const Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  inputDecorationTheme: inputTheme(
    const Color.fromARGB(255, 254, 254, 254),
    const Color.fromARGB(255, 163, 166, 174),
  ),
  dataTableTheme: DataTableThemeData(
    headingRowColor: WidgetStateColor.resolveWith((states) {
      return const Color.fromARGB(255, 32, 33, 35);
    }),
    headingTextStyle: const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
    ),
    dataTextStyle: const TextStyle(
      color: Color.fromARGB(255, 220, 220, 220),
    ),
    dataRowColor: WidgetStateColor.resolveWith((states) {
      return const Color.fromARGB(255, 46, 46, 60);
    }),
  ),
);
