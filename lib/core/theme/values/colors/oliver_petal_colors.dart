import 'package:flutter/material.dart';
import 'app_colors.dart';

class OliverPetalColors implements AppColors {
  static const Color _primary = Color(0xFF3F4D16); // Deep olive green

  @override
  Color get primary => _primary;

  @override
  Color get primaryVariant => Color(0xFF2E370F); // Even deeper olive

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => Color(0xFFDCE6C2); // Light green-olive wash

  @override
  Color get onPrimaryContainer => Color(0xFF26330C); // Darker contrast for text

  @override
  Color get primaryFixed => _primary;

  @override
  Color get primaryFixedDim => Color(0xFF5D6B2B); // Slightly muted mid-tone olive

  @override
  Color get onPrimaryFixed => Colors.white;

  @override
  Color get onPrimaryFixedVariant => Colors.white70;

  @override
  Color get secondary => Color(0xFF6F8E25); // Olive-adjacent leafy green

  @override
  Color get secondaryVariant => Color(0xFF566D1D); // Deeper secondary

  @override
  Color get onSecondary => Colors.white;

  @override
  Color get secondaryContainer => Color(0xFFEAF4D5); // Light soft green

  @override
  Color get onSecondaryContainer => Color(0xFF344411); // Text contrast for secondary

  @override
  Color get secondaryFixed => Color(0xFF9DBF63);

  @override
  Color get secondaryFixedDim => Color(0xFF7F9E4D);

  @override
  Color get onSecondaryFixed => Colors.white;

  @override
  Color get onSecondaryFixedVariant => Colors.white70;

  @override
  Color get tertiary => Color(0xFFB3C988); // Olive beige green

  @override
  Color get onTertiary => Color(0xFF2B3810);

  @override
  Color get tertiaryContainer => Color(0xFFF2F7E2); // Pastel background

  @override
  Color get onTertiaryContainer => Color(0xFF3C4E16);

  @override
  Color get tertiaryFixed => Color(0xFFCDD8AA);

  @override
  Color get tertiaryFixedDim => Color(0xFFB4C28F);

  @override
  Color get onTertiaryFixed => Color(0xFF2B3810);

  @override
  Color get onTertiaryFixedVariant => Colors.black54;

  @override
  Color get error => Color(0xFFB00020);

  @override
  Color get onError => Colors.white;

  @override
  Color get errorContainer => Color(0xFFFFDAD4);

  @override
  Color get onErrorContainer => Color(0xFF410002);

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
  Color get background => Color(0xFFF9FFF2); // Very light olive hint

  @override
  Color get onBackground => Color(0xFF1B1B1F);

  @override
  Color get surface => Colors.white;

  @override
  Color get onSurface => Color(0xFF1B1B1F);

  @override
  Color get surfaceDim => Color(0xFFF2F2F2);

  @override
  Color get surfaceBright => Color(0xFFFFFFFF);

  @override
  Color get surfaceContainerLowest => Color(0xFFFFFFFF);

  @override
  Color get surfaceContainerLow => Color(0xFFF4F4F4);

  @override
  Color get surfaceContainer => Color(0xFFE8ECD9);

  @override
  Color get surfaceContainerHigh => Color(0xFFDDE3C7);

  @override
  Color get surfaceContainerHighest => Color(0xFFC3CBAF);

  @override
  Color get surfaceVariant => Color(0xFFDCE6C2);

  @override
  Color get onSurfaceVariant => Color(0xFF49454F);

  @override
  Color get surfaceTint => _primary;

  @override
  Color get outline => Color(0xFF9DA49B);

  @override
  Color get outlineVariant => Color(0xFFE1E5D8);

  @override
  Color get shadow => Colors.black12;

  @override
  Color get scrim => Colors.black38;

  @override
  Color get inverseSurface => Color(0xFF2E2E2E);

  @override
  Color get onInverseSurface => Colors.white;

  @override
  Color get inversePrimary => Color(0xFFB3C988);

  @override
  Color get selected => _primary;

  @override
  Color get unSelected => const Color.fromARGB(160, 255, 255, 255);

  @override
  Color get disabled => const Color.fromARGB(144, 255, 255, 255);
}
