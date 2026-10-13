// ============================================================================
// core/theme/app_theme.dart - Sistema de Design InclusIMove
// ============================================================================
// Define paleta de cores, tipografia e temas claro/escuro com Material 3.
// Cores principais: Laranja #FF6B35 | Azul Escuro #0D1B3E | Branco
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Classe estática que centraliza todo o sistema de design do app
class AppTheme {
  AppTheme._(); // Construtor privado — não instanciar

  // ── Paleta de Cores ─────────────────────────────────────────────────────────

  /// Laranja principal — botões de ação, destaques, CTAs
  static const Color primaryOrange = Color(0xFFFF6B35);

  /// Laranja mais escuro para estado pressed/hover
  static const Color primaryOrangeDark = Color(0xFFE85520);

  /// Azul escuro — fundo principal no dark mode
  static const Color backgroundNavy = Color(0xFF0D1B3E);

  /// Azul médio — cards e containers no dark mode
  static const Color surfaceNavy = Color(0xFF1A2B52);

  /// Azul claro — para superfícies secundárias
  static const Color surfaceNavyLight = Color(0xFF243563);

  /// Branco puro
  static const Color white = Color(0xFFFFFFFF);

  /// Cinza suave para texto secundário
  static const Color textSecondary = Color(0xFFB0BEC5);

  /// Verde de sucesso
  static const Color success = Color(0xFF4CAF50);

  /// Vermelho de erro / SOS
  static const Color error = Color(0xFFF44336);

  /// Amarelo de aviso
  static const Color warning = Color(0xFFFFC107);

  // ── Tema Escuro (padrão do app) ────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Esquema de cores
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        onPrimary: white,
        secondary: Color(0xFF64B5F6),
        onSecondary: backgroundNavy,
        surface: surfaceNavy,
        onSurface: white,
        error: error,
        onError: white,
      ),

      // Cor de fundo
      scaffoldBackgroundColor: backgroundNavy,

      // Tipografia — Google Fonts Inter
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: white,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: white,
          ),
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: white,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: white,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: white,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: white,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            height: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: white,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: white,
        ),
        iconTheme: const IconThemeData(color: white, size: 24),
      ),

      // Botão elevado (CTA principal)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 56), // altura acessível
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          elevation: 4,
          shadowColor: primaryOrange.withOpacity(0.4),
        ),
      ),

      // Botão outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange, width: 2),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Campo de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceNavy,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: surfaceNavyLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 15),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 15),
        floatingLabelStyle: const TextStyle(
          color: primaryOrange,
          fontSize: 13,
        ),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),

      // Card
      cardTheme: CardTheme(
        color: surfaceNavy,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: surfaceNavyLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceNavy,
        selectedItemColor: primaryOrange,
        unselectedItemColor: textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        elevation: 16,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surfaceNavyLight,
        selectedColor: primaryOrange.withOpacity(0.2),
        labelStyle: const TextStyle(color: white, fontSize: 13),
        side: const BorderSide(color: surfaceNavyLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divisor
      dividerTheme: const DividerThemeData(
        color: surfaceNavyLight,
        thickness: 1,
        space: 1,
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryOrange,
        foregroundColor: white,
        elevation: 8,
        shape: CircleBorder(),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceNavyLight,
        contentTextStyle: GoogleFonts.inter(
          color: white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Tema Claro ─────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: primaryOrange,
        onPrimary: white,
        secondary: Color(0xFF1565C0),
        onSecondary: white,
        surface: Color(0xFFF5F7FF),
        onSurface: Color(0xFF1A2B52),
        error: error,
        onError: white,
      ),

      scaffoldBackgroundColor: const Color(0xFFF0F2F8),

      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),

      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: backgroundNavy,
        ),
        iconTheme: const IconThemeData(color: backgroundNavy, size: 24),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 4,
          shadowColor: primaryOrange.withOpacity(0.3),
        ),
      ),

      cardTheme: CardTheme(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE0E4F0), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
