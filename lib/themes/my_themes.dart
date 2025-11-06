import 'package:flutter/material.dart';

class MyThemes {
  // WARNA UTAMA APLIKASI
  static const Color primaryColor = Colors.orangeAccent;
  static const Color secondaryColor = Color(0xFFFFD180);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color greyText = Color(0xFF4A4A4A);
  static const Color greyColor = Color.fromRGBO(217, 217, 217, 1);

  // GAYA TEKS UMUM
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: greyText,
  );

  // TEMA GLOBAL UNTUK MATERIAL APP
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyMedium: subtitle,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    useMaterial3: true,
  );
}
