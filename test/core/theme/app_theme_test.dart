import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/core/theme/app_theme.dart';

void main() {
  final lightThemes = [
    AppTheme.blueOcean,
    AppTheme.elegance,
    AppTheme.oliverPetal,
  ];
  final darkThemes = [
    AppTheme.darkAbyss,
    AppTheme.blueOceanDark,
    AppTheme.eleganceDark,
    AppTheme.oliverPetalDark,
  ];

  test('light and dark themes keep shared surfaces and dialogs in sync', () {
    for (final theme in [...lightThemes, ...darkThemes]) {
      expect(theme.cardTheme.color, theme.colorScheme.surface);
      expect(theme.dialogTheme.backgroundColor, theme.colorScheme.surface);
      expect(theme.datePickerTheme.backgroundColor, theme.colorScheme.surface);
      expect(
        theme.snackBarTheme.backgroundColor,
        theme.colorScheme.inverseSurface,
      );
      expect(
        theme.snackBarTheme.contentTextStyle?.color,
        theme.colorScheme.onInverseSurface,
      );
      expect(theme.progressIndicatorTheme.color, theme.colorScheme.primary);
    }
  });

  test('each theme variant declares its intended brightness', () {
    for (final theme in lightThemes) {
      expect(theme.colorScheme.brightness, Brightness.light);
    }
    for (final theme in darkThemes) {
      expect(theme.colorScheme.brightness, Brightness.dark);
    }
  });
}
