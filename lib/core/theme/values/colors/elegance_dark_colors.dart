import 'package:flutter/material.dart';
import 'app_colors.dart';

class EleganceDarkColors extends AppColors {
  static const Color _primary = Color(0xFF540366); // Deep royal purple

  @override
  Color get primary => _primary;

  @override
  Color get primaryVariant => const Color(0xFF3E014C);

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => const Color(0xFF7A2F91);

  @override
  Color get onPrimaryContainer => const Color(0xFFEAD1F4);

  @override
  Color get primaryFixed => _primary;

  @override
  Color get primaryFixedDim => const Color(0xFF9855B4);

  @override
  Color get onPrimaryFixed => Colors.white;

  @override
  Color get onPrimaryFixedVariant => Colors.white70;

  @override
  Color get secondary => const Color(0xFF8E24AA);

  @override
  Color get secondaryVariant => const Color(0xFF6A1B9A);

  @override
  Color get onSecondary => Colors.white;

  @override
  Color get secondaryContainer => const Color(0xFF5A1E70);

  @override
  Color get onSecondaryContainer => const Color(0xFFEED7F4);

  @override
  Color get secondaryFixed => const Color(0xFFB980CC);

  @override
  Color get secondaryFixedDim => const Color(0xFF9855B4);

  @override
  Color get onSecondaryFixed => Colors.white;

  @override
  Color get onSecondaryFixedVariant => Colors.white70;

  @override
  Color get tertiary => const Color(0xFFD500F9);

  @override
  Color get onTertiary => Colors.white;

  @override
  Color get tertiaryContainer => const Color(0xFF700087);

  @override
  Color get onTertiaryContainer => const Color(0xFFF3E5F5);

  @override
  Color get tertiaryFixed => const Color(0xFFC48BCE);

  @override
  Color get tertiaryFixedDim => const Color(0xFFAA65B4);

  @override
  Color get onTertiaryFixed => Colors.white;

  @override
  Color get onTertiaryFixedVariant => Colors.white70;

  @override
  Color get error => const Color(0xFFCF6679);

  @override
  Color get onError => Colors.black;

  @override
  Color get errorContainer => const Color(0xFFB00020);

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
  Color get background => Color.fromARGB(255, 21, 1, 26); // 🖤 True dark mode

  @override
  Color get onBackground => const Color(0xFFECE0F2); // Soft off-white with purple hint

  @override
  Color get surface => Color.fromARGB(255, 16, 0, 20); // Dark purple-tinted surface

  @override
  Color get onSurface => const Color(0xFFEDE0F0);

  @override
  Color get surfaceDim => const Color(0xFF1A161F);

  @override
  Color get surfaceBright => const Color(0xFF29222F);

  @override
  Color get surfaceContainerLowest => const Color(0xFF18131C);

  @override
  Color get surfaceContainerLow => const Color(0xFF211B27);

  @override
  Color get surfaceContainer => const Color(0xFF2A2130);

  @override
  Color get surfaceContainerHigh => const Color(0xFF35293C);

  @override
  Color get surfaceContainerHighest => const Color(0xFF443551);

  @override
  Color get surfaceVariant => const Color(0xFF392C42); // A bit of purple-tinted variant

  @override
  Color get onSurfaceVariant => const Color(0xFFD6A7E6);

  @override
  Color get surfaceTint => _primary;

  @override
  Color get outline => const Color(0xFF8A7F99);

  @override
  Color get outlineVariant => const Color(0xFF4D4157);

  @override
  Color get shadow => Colors.black;

  @override
  Color get scrim => Colors.black87;

  @override
  Color get inverseSurface => const Color(0xFFEDE0F0);

  @override
  Color get onInverseSurface => const Color(0xFF1B1B1F);

  @override
  Color get inversePrimary => const Color(0xFFD6A7E6);

  @override
  Color get selected => _primary;

  @override
  Color get unSelected => const Color.fromARGB(160, 255, 255, 255); // Slight transparency

  @override
  Color get disabled => const Color.fromARGB(90, 255, 255, 255); // More transparency
}
