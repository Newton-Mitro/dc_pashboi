import 'package:flutter/material.dart';
import 'app_colors.dart';

class DarkAbyssColors extends AppColors {
  static const Color _primary = Color.fromARGB(255, 29, 36, 48);

  @override
  Color get primary => _primary;

  @override
  Color get primaryVariant => Color(0xFF001F5C); // Darker shade

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => Color(0xFF25477A);

  @override
  Color get onPrimaryContainer => Colors.white;

  @override
  Color get primaryFixed => _primary;

  @override
  Color get primaryFixedDim => Color(0xFF002C5B);

  @override
  Color get onPrimaryFixed => Colors.white;

  @override
  Color get onPrimaryFixedVariant => Colors.white70;

  @override
  Color get secondary => Color(0xFF4A6FA5);

  @override
  Color get secondaryVariant => Color(0xFF2C4D7A);

  @override
  Color get onSecondary => Colors.white;

  @override
  Color get secondaryContainer => Color(0xFF3B5A8D);

  @override
  Color get onSecondaryContainer => Colors.white;

  @override
  Color get secondaryFixed => Color(0xFF4A6FA5);

  @override
  Color get secondaryFixedDim => Color(0xFF365A82);

  @override
  Color get onSecondaryFixed => Colors.white;

  @override
  Color get onSecondaryFixedVariant => Colors.white70;

  @override
  Color get tertiary => Color.fromARGB(255, 159, 184, 224);

  @override
  Color get onTertiary => Colors.white;

  @override
  Color get tertiaryContainer => Color(0xFF5A7390);

  @override
  Color get onTertiaryContainer => Colors.white;

  @override
  Color get tertiaryFixed => Color(0xFF7A91B5);

  @override
  Color get tertiaryFixedDim => Color(0xFF5A7390);

  @override
  Color get onTertiaryFixed => Colors.white;

  @override
  Color get onTertiaryFixedVariant => Colors.white70;

  @override
  Color get error => Color(0xFFCF6679);

  @override
  Color get onError => Colors.black;

  @override
  Color get errorContainer => Color(0xFFB00020);

  @override
  Color get onErrorContainer => Colors.white;

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

  @override
  Color get background => Color(0xFF121212);

  @override
  Color get onBackground => Colors.white;

  @override
  Color get surface => Color(0xFF1E1E1E);

  @override
  Color get onSurface => Colors.white;

  @override
  Color get surfaceDim => Color(0xFF101010);

  @override
  Color get surfaceBright => Color(0xFF2C2C2C);

  @override
  Color get surfaceContainerLowest => Color(0xFF0F0F0F);

  @override
  Color get surfaceContainerLow => Color(0xFF1A1A1A);

  @override
  Color get surfaceContainer => Color(0xFF232323);

  @override
  Color get surfaceContainerHigh => Color(0xFF2D2D2D);

  @override
  Color get surfaceContainerHighest => Color(0xFF383838);

  @override
  Color get surfaceVariant => Color(0xFF2A2A2A);

  @override
  Color get onSurfaceVariant => Colors.white70;

  @override
  Color get surfaceTint => _primary;

  @override
  Color get outline => Color(0xFF444444);

  @override
  Color get outlineVariant => Color(0xFF666666);

  @override
  Color get shadow => Colors.black;

  @override
  Color get scrim => Colors.black54;

  @override
  Color get inverseSurface => Colors.white;

  @override
  Color get onInverseSurface => Color(0xFF1E1E1E);

  @override
  Color get inversePrimary => Color(0xFF90CAF9);

  @override
  Color get selected => _primary;

  @override
  Color get unSelected => const Color.fromARGB(160, 255, 255, 255);

  @override
  Color get disabled => const Color.fromARGB(144, 255, 255, 255);
}
