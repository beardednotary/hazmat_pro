import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HMColors {
  HMColors._();

  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF242424);
  static const Color headerBg = Color(0xFF141414);

  static const Color hazardYellow = Color(0xFFFFD400);
  static const Color hazardYellowPress = Color(0x33FFD400);

  static const Color hazardOrange = Color(0xFFFF6D00);
  static const Color dangerRed = Color(0xFFE5342A);
  static const Color dangerRedPress = Color(0x33E5342A);

  // DOT hazard class accent colors — used on placard tiles
  static const Color classExplosive = Color(0xFFFF6D00);
  static const Color classGas = Color(0xFF2E9E4F);
  static const Color classFlammableGas = Color(0xFFE5342A);
  static const Color classToxicGas = Color(0xFFEAEAEA);
  static const Color classFlammableLiquid = Color(0xFFE5342A);
  static const Color classFlammableSolid = Color(0xFFE5342A);
  static const Color classOxidizer = Color(0xFFFFD400);
  static const Color classPoison = Color(0xFFEAEAEA);
  static const Color classRadioactive = Color(0xFFFFD400);
  static const Color classCorrosive = Color(0xFFEAEAEA);
  static const Color classMisc = Color(0xFFB0AFA8);

  static const Color primaryText = Color(0xFFEAEAEA);
  static const Color secondaryText = Color(0xFF8E8E93);
  static const Color dimText = Color(0xFF48484A);

  static const Color divider = Color(0xFF2C2C2E);
  static const Color border = Color(0xFF3A3A3C);
}

class HMTextStyles {
  HMTextStyles._();

  // Flat, no glow — big condensed numerals for placard classes / UN numbers.
  static TextStyle heroNumber({double fontSize = 30, Color? color}) =>
      GoogleFonts.bebasNeue(
        fontSize: fontSize,
        color: color ?? HMColors.primaryText,
        letterSpacing: 1,
      );

  // Screen title in the header — flat bold, not an LCD readout.
  static TextStyle screenTitle({double fontSize = 24}) => GoogleFonts.oswald(
        fontSize: fontSize,
        color: HMColors.primaryText,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get dataMono => GoogleFonts.robotoMono(
        fontSize: 12,
        color: HMColors.secondaryText,
        letterSpacing: 0.3,
      );

  static TextStyle get codeLabel => GoogleFonts.robotoMono(
        fontSize: 15,
        color: HMColors.hazardYellow,
        letterSpacing: 0.3,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get termLabel => GoogleFonts.oswald(
        fontSize: 17,
        color: HMColors.primaryText,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  static TextStyle get sectionHeader => GoogleFonts.oswald(
        fontSize: 11,
        color: HMColors.secondaryText,
        letterSpacing: 2.5,
        fontWeight: FontWeight.w600,
      );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: HMColors.primaryText,
    height: 1.4,
  );

  static const TextStyle dimBody = TextStyle(
    fontSize: 13,
    color: HMColors.secondaryText,
    height: 1.3,
  );
}

class HMTheme {
  HMTheme._();

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: HMColors.background,
        colorScheme: const ColorScheme.dark(
          primary: HMColors.hazardYellow,
          secondary: HMColors.hazardYellow,
          surface: HMColors.surface,
        ),
        dividerColor: HMColors.divider,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: HMColors.primaryText),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: HMColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: HMColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: HMColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: HMColors.hazardYellow, width: 1.5),
          ),
          hintStyle: const TextStyle(color: HMColors.dimText),
          prefixIconColor: HMColors.dimText,
        ),
      );
}
