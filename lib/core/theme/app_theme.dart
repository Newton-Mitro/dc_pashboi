import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pashboi/core/theme/theme_data/blue_ocean_dark_theme_data.dart';
import 'package:pashboi/core/theme/theme_data/elegance_dark_theme_data.dart';
import 'package:pashboi/core/theme/theme_data/elegance_theme_data.dart';
import 'package:pashboi/core/theme/theme_data/oliver_petal_dark_theme_data.dart';
import 'package:pashboi/core/theme/theme_data/oliver_petal_theme_data.dart';
import 'package:pashboi/core/theme/theme_data/dark_abyss_theme_data.dart';
import 'package:pashboi/core/theme/theme_data/blue_ocean_theme_data.dart';

class AppTheme {
  static final ThemeData darkAbyss = _withColorDefaults(darkAbyssThemeData);
  static final ThemeData blueOcean = _withColorDefaults(blueOceanThemeData);
  static final ThemeData blueOceanDark = _withColorDefaults(
    blueOceanDarkThemeData,
  );
  static final ThemeData oliverPetal = _withColorDefaults(oliverPetalThemeData);
  static final ThemeData oliverPetalDark = _withColorDefaults(
    oliverPetalDarkThemeData,
  );
  static final ThemeData elegance = _withColorDefaults(eleganceThemeData);
  static final ThemeData eleganceDark = _withColorDefaults(
    eleganceDarkThemeData,
  );

  static ThemeData _withColorDefaults(ThemeData theme) {
    final colors = theme.colorScheme;
    final systemBrightness =
        theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: systemBrightness,
          systemNavigationBarColor: colors.surface,
          systemNavigationBarIconBrightness: systemBrightness,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: TextStyle(color: colors.error),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.outline),
        ),
      ),
      cardTheme: CardThemeData(color: colors.surface),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: colors.onSurface,
        ),
        contentTextStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colors.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        surfaceTintColor: colors.surfaceTint,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colors.surface,
        headerBackgroundColor: colors.primary,
        headerForegroundColor: colors.onPrimary,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.onPrimary;
          return colors.onSurface;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return null;
        }),
        todayForegroundColor: WidgetStateProperty.all(colors.primary),
        todayBorder: BorderSide(color: colors.primary),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colors.surface,
        dialBackgroundColor: colors.surfaceContainerHighest,
        dialHandColor: colors.primary,
        hourMinuteColor: colors.surfaceContainerHighest,
        hourMinuteTextColor: colors.onSurface,
        dayPeriodColor: colors.secondaryContainer,
        dayPeriodTextColor: colors.onSecondaryContainer,
        helpTextStyle: theme.textTheme.labelMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.inverseSurface,
        contentTextStyle: TextStyle(color: colors.onInverseSurface),
        actionTextColor: colors.inversePrimary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainerHighest,
        circularTrackColor: colors.surfaceContainerHighest,
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionColor: colors.primary.withValues(alpha: 0.3),
        selectionHandleColor: colors.primary,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return null;
        }),
        checkColor: WidgetStateProperty.all(colors.onPrimary),
        side: BorderSide(color: colors.outline),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return colors.onSurfaceVariant;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.onPrimary;
          return colors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return colors.surfaceContainerHighest;
        }),
      ),
    );
  }
}
