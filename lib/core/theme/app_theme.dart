import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ألوان حسب طلبك
  static const Color primary = Color(0xFFD0BB96); // اللون العام
  static const Color secondary = Color(0xFF455C7B); // للهيرو/العناوين
  static const Color bg = Color(0xFFD0BB96); // خلفيات الصفحات نفس اللون

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: Colors.white,
      background: bg,
      brightness: Brightness.light,
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme).apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
     appBarTheme: const AppBarTheme(
  centerTitle: true,
  elevation: 0,
  backgroundColor: Color(0xFF27456B), // اللون المطلوب
  foregroundColor: Colors.white,      // النص والأيقونات أبيض
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),

      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white70),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
