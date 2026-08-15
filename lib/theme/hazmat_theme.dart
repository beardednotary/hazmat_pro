import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HMColors {
  HMColors._();

  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF252525);

  static const Color hazardYellow = Color(0xFFFFD400);
  static const Color hazardYellowBright = Color(0xFFFFE666);
  static const Color hazardYellowGlow = Color(0x40FFD400);
  static const Color panelBg = Color(0xFF0A0900);
  static const Color panelBorder = Color(0xFF2A2400);

  static const Color hazardOrange = Color(0xFFFF6D00);
  static const Color dangerRed = Color(0xFFE5342A);
  static const Color dangerRedBg = Color(0xFF1A0000);
  static const Color dangerRedGlow = Color(0x40E5342A);

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

  static TextStyle placardDisplay({double fontSize = 34}) =>
      GoogleFonts.bebasNeue(
        fontSize: fontSize,
        color: HMColors.hazardYellow,
        letterSpacing: 2,
        shadows: const [
          Shadow(color: Color(0x80FFD400), blurRadius: 10),
        ],
      );

  static TextStyle get classNumber => GoogleFonts.bebasNeue(
        fontSize: 30,
        color: HMColors.hazardYellow,
        letterSpacing: 1,
        shadows: const [Shadow(color: Color(0x60FFD400), blurRadius: 6)],
      );

  static TextStyle get dataMono => GoogleFonts.robotoMono(
        fontSize: 12,
        color: HMColors.secondaryText,
        letterSpacing: 0.5,
      );

  static TextStyle get codeLabel => GoogleFonts.robotoMono(
        fontSize: 16,
        color: HMColors.hazardYellow,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get termLabel => GoogleFonts.oswald(
        fontSize: 17,
        color: HMColors.hazardYellow,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
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
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: HMColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: HMColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: HMColors.hazardYellow, width: 1.5),
          ),
          hintStyle: const TextStyle(color: HMColors.dimText),
          prefixIconColor: HMColors.dimText,
        ),
      );
}
