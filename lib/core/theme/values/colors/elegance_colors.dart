import 'package:flutter/material.dart';
import 'app_colors.dart';

class EleganceColors extends AppColors {
  static const Color _primary = Color(0xFF540366); // Deep royal purple

  @override
  Color get primary => _primary;

  @override
  Color get primaryVariant => const Color(0xFF3E014C); // Even darker purple

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => const Color(0xFFD6A7E6); // Light lavender tint

  @override
  Color get onPrimaryContainer => const Color(0xFF2C0033); // Deepest readable text

  @override
  Color get primaryFixed => _primary;

  @override
  Color get primaryFixedDim => const Color(0xFF7A2F91); // Muted version

  @override
  Color get onPrimaryFixed => Colors.white;

  @override
  Color get onPrimaryFixedVariant => Colors.white70;

  @override
  Color get secondary => const Color(0xFF8E24AA); // Muted magenta

  @override
  Color get secondaryVariant => const Color(0xFF6A1B9A); // Stronger violet tone

  @override
  Color get onSecondary => Colors.white;

  @override
  Color get secondaryContainer => const Color(0xFFEED7F4); // Soft pastel purple

  @override
  Color get onSecondaryContainer => const Color(0xFF3B0053); // Contrast text

  @override
  Color get secondaryFixed => const Color(0xFFCE93D8);

  @override
  Color get secondaryFixedDim => const Color(0xFFB980CC);

  @override
  Color get onSecondaryFixed => Colors.white;

  @override
  Color get onSecondaryFixedVariant => Colors.white70;

  @override
  Color get tertiary => const Color(0xFFD500F9); // Bright neon purple

  @override
  Color get onTertiary => Colors.white;

  @override
  Color get tertiaryContainer => const Color(0xFFF3E5F5);

  @override
  Color get onTertiaryContainer => const Color(0xFF4A0072);

  @override
  Color get tertiaryFixed => const Color(0xFFE1BEE7);

  @override
  Color get tertiaryFixedDim => const Color(0xFFC48BCE);

  @override
  Color get onTertiaryFixed => Colors.white;

  @override
  Color get onTertiaryFixedVariant => Colors.white70;

  @override
  Color get error => const Color(0xFFB00020);

  @override
  Color get onError => Colors.white;

  @override
  Color get errorContainer => const Color(0xFFFFDAD4);

  @override
  Color get onErrorContainer => const Color(0xFF410002);

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
  Color get background => const Color(0xFFFAF5FB); // Subtle soft lilac

  @override
  Color get onBackground => const Color(0xFF1B1B1F);

  @override
  Color get surface => Colors.white;

  @override
  Color get onSurface => const Color(0xFF1B1B1F);

  @override
  Color get surfaceDim => const Color(0xFFF2F2F2);

  @override
  Color get surfaceBright => const Color(0xFFFFFFFF);

  @override
  Color get surfaceContainerLowest => const Color(0xFFFFFFFF);

  @override
  Color get surfaceContainerLow => const Color(0xFFF6F0F8);

  @override
  Color get surfaceContainer => const Color(0xFFEDE0F0);

  @override
  Color get surfaceContainerHigh => const Color(0xFFD9C8DF);

  @override
  Color get surfaceContainerHighest => const Color(0xFFC6B2CC);

  @override
  Color get surfaceVariant => const Color(0xFFD6A7E6); // Matches primaryContainer

  @override
  Color get onSurfaceVariant => const Color(0xFF49454F);

  @override
  Color get surfaceTint => _primary;

  @override
  Color get outline => const Color(0xFF7D7D7D);

  @override
  Color get outlineVariant => const Color(0xFFE1E1E1);

  @override
  Color get shadow => Colors.black12;

  @override
  Color get scrim => Colors.black38;

  @override
  Color get inverseSurface => const Color(0xFF2E2E2E);

  @override
  Color get onInverseSurface => Colors.white;

  @override
  Color get inversePrimary => const Color(0xFFDD9ADD); // Light lavender inverse

  @override
  Color get selected => _primary;

  @override
  Color get unSelected => const Color(0xFFF0E5F5); // Soft, transparent tone

  @override
  Color get disabled => const Color(0xFFDDD0E0);
}
