import 'package:flutter/material.dart';
import 'package:pashboi/core/theme/values/colors/app_colors.dart';

class BlueOceanColors implements AppColors {
  // Base Colors
  static const Color _primary = Color.fromARGB(255, 1, 34, 83);
  static const Color _secondary = Color(0xFF00639A);
  static const Color _tertiary = Color(0xFF7B5295);

  @override
  Color get primary => _primary;

  @override
  Color get primaryVariant => Color(0xFF002F5F);
  @override
  Color get onPrimary => Colors.white;
  @override
  Color get primaryContainer => Color(0xFFD5E3FF);
  @override
  Color get onPrimaryContainer => _primary;
  @override
  Color get primaryFixed => Color(0xFFB6CFFF);
  @override
  Color get primaryFixedDim => Color(0xFF8AAEFF);
  @override
  Color get onPrimaryFixed => _primary;
  @override
  Color get onPrimaryFixedVariant => primaryVariant;

  @override
  Color get secondary => _secondary;
  @override
  Color get secondaryVariant => Color(0xFF004370);
  @override
  Color get onSecondary => Colors.white;
  @override
  Color get secondaryContainer => Color(0xFFCDE5FF);
  @override
  Color get onSecondaryContainer => _secondary;
  @override
  Color get secondaryFixed => Color(0xFFB8D8FF);
  @override
  Color get secondaryFixedDim => Color(0xFF90C9FF);
  @override
  Color get onSecondaryFixed => _secondary;
  @override
  Color get onSecondaryFixedVariant => secondaryVariant;

  @override
  Color get tertiary => const Color.fromARGB(255, 224, 188, 247);
  @override
  Color get onTertiary => Colors.white;
  @override
  Color get tertiaryContainer => Color(0xFFF3DAFF);
  @override
  Color get onTertiaryContainer => _tertiary;
  @override
  Color get tertiaryFixed => Color(0xFFE6C6FF);
  @override
  Color get tertiaryFixedDim => Color(0xFFCBA7F8);
  @override
  Color get onTertiaryFixed => _tertiary;
  @override
  Color get onTertiaryFixedVariant => Color(0xFF5E3E73);

  @override
  Color get error => Color(0xFFB3261E);
  @override
  Color get onError => Colors.white;
  @override
  Color get errorContainer => Color(0xFFF9DEDC);
  @override
  Color get onErrorContainer => Color(0xFF410E0B);

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
  Color get background => Color.fromARGB(255, 210, 224, 245);
  @override
  Color get onBackground => Color(0xFF1C1B1F);

  @override
  Color get surface => Color(0xFFFFFFFF);
  @override
  Color get onSurface => Color(0xFF1C1B1F);
  @override
  Color get surfaceDim => Color(0xFFE7E0EC);
  @override
  Color get surfaceBright => Color(0xFFFFFBFE);
  @override
  Color get surfaceContainerLowest => Color(0xFFFFFFFF);
  @override
  Color get surfaceContainerLow => Color(0xFFF7F2FA);
  @override
  Color get surfaceContainer => Color(0xFFE7E0EC);
  @override
  Color get surfaceContainerHigh => Color(0xFFD7D0DC);
  @override
  Color get surfaceContainerHighest => Color(0xFFC7C2CC);
  @override
  Color get surfaceVariant => Color(0xFFE7E0EC);
  @override
  Color get onSurfaceVariant => Color(0xFF49454F);
  @override
  Color get surfaceTint => _primary;

  @override
  Color get outline => Color(0xFF79747E);
  @override
  Color get outlineVariant => Color(0xFFCAC4D0);
  @override
  Color get shadow => Colors.black;
  @override
  Color get scrim => const Color.fromARGB(62, 0, 0, 0);

  @override
  Color get inverseSurface => Color(0xFF313033);
  @override
  Color get onInverseSurface => Color(0xFFF4EFF4);
  @override
  Color get inversePrimary => Color(0xFFB6CFFF);

  @override
  Color get selected => const Color.fromARGB(255, 205, 216, 233);
  @override
  Color get unSelected => Color.fromARGB(255, 137, 157, 172);
  @override
  Color get disabled => Color(0xFFBDBDBD);
}
