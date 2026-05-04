import 'package:flutter/material.dart';
import 'app_colors.dart';

class OliverPetalDarkColors implements AppColors {
  static const Color _primary = Color(0xFF3F4D16); // Deep olive green

  @override
  Color get primary => _primary;

  @override
  Color get primaryVariant => Color(0xFF2E370F);

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => Color(0xFF566D1D);

  @override
  Color get onPrimaryContainer => Color(0xFFEAF4D5);

  @override
  Color get primaryFixed => _primary;

  @override
  Color get primaryFixedDim => Color(0xFF5D6B2B);

  @override
  Color get onPrimaryFixed => Colors.white;

  @override
  Color get onPrimaryFixedVariant => Colors.white70;

  @override
  Color get secondary => Color(0xFF9DBF63);

  @override
  Color get secondaryVariant => Color(0xFF7F9E4D);

  @override
  Color get onSecondary => Colors.black;

  @override
  Color get secondaryContainer => Color(0xFF2E3C15);

  @override
  Color get onSecondaryContainer => Color(0xFFDDEBC3);

  @override
  Color get secondaryFixed => Color(0xFF9DBF63);

  @override
  Color get secondaryFixedDim => Color(0xFF7F9E4D);

  @override
  Color get onSecondaryFixed => Colors.black;

  @override
  Color get onSecondaryFixedVariant => Colors.black54;

  @override
  Color get tertiary => Color(0xFFB3C988);

  @override
  Color get onTertiary => Color(0xFF1C230B);

  @override
  Color get tertiaryContainer => Color(0xFF3A4715);

  @override
  Color get onTertiaryContainer => Color(0xFFF2F7E2);

  @override
  Color get tertiaryFixed => Color(0xFFCDD8AA);

  @override
  Color get tertiaryFixedDim => Color(0xFFB4C28F);

  @override
  Color get onTertiaryFixed => Color(0xFF2B3810);

  @override
  Color get onTertiaryFixedVariant => Colors.white70;

  @override
  Color get error => Color(0xFFCF6679);

  @override
  Color get onError => Colors.black;

  @override
  Color get errorContainer => Color(0xFF8C1D1D);

  @override
  Color get onErrorContainer => Color(0xFFFFDAD4);

  @override
  Color get success => Color(0xFF5CB31E);
  @override
  Color get onSuccess => Colors.white;
  @override
  Color get successContainer => Color(0xFFDEF9DC);
  @override
  Color get onSuccessContainer => Color(0xFF0B410C);

  @override
  Color get warning => Color(0xFFB3771E);
  @override
  Color get onWarning => Colors.white;
  @override
  Color get warningContainer => Color(0xFFF9EBDC);
  @override
  Color get onWarningContainer => Color(0xFF41320B);

  // 🌑 DARK THEME ADJUSTMENTS BELOW

  @override
  Color get background => Color.fromARGB(255, 26, 32, 10); // Deep olive charcoal

  @override
  Color get onBackground => Color(0xFFDCE6C2); // Soft olive white

  @override
  Color get surface => Color.fromARGB(255, 18, 22, 7); // Earthy dark surface

  @override
  Color get onSurface => Color(0xFFEAF4D5); // Gentle light olive

  @override
  Color get surfaceDim => Color(0xFF1A1C14);

  @override
  Color get surfaceBright => Color(0xFF23271B);

  @override
  Color get surfaceContainerLowest => Color(0xFF181A13);

  @override
  Color get surfaceContainerLow => Color(0xFF1F2418);

  @override
  Color get surfaceContainer => Color(0xFF262C1D);

  @override
  Color get surfaceContainerHigh => Color(0xFF2F3721);

  @override
  Color get surfaceContainerHighest => Color(0xFF374227);

  @override
  Color get surfaceVariant => Color(0xFF4E5C2C); // Muted moss

  @override
  Color get onSurfaceVariant => Color(0xFFC3CBAF);

  @override
  Color get surfaceTint => _primary;

  @override
  Color get outline => Color(0xFF7D8B6A); // Faded sage

  @override
  Color get outlineVariant => Color(0xFF424C2B);

  @override
  Color get shadow => Colors.black54;

  @override
  Color get scrim => Colors.black87;

  @override
  Color get inverseSurface => Color(0xFFE9F2D9);

  @override
  Color get onInverseSurface => Color(0xFF1B1B1F);

  @override
  Color get inversePrimary => Color(0xFFB3C988);

  @override
  Color get selected => _primary;

  @override
  Color get unSelected => Color(0xFF424C2B);

  @override
  Color get disabled => Color(0xFF6A7552);
}
