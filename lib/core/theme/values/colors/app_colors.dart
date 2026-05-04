import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary colors
  Color get primary;
  Color get primaryVariant;
  Color get onPrimary;
  Color get primaryContainer;
  Color get onPrimaryContainer;
  Color get primaryFixed;
  Color get primaryFixedDim;
  Color get onPrimaryFixed;
  Color get onPrimaryFixedVariant;

  // Secondary colors
  Color get secondary;
  Color get secondaryVariant;
  Color get onSecondary;
  Color get secondaryContainer;
  Color get onSecondaryContainer;
  Color get secondaryFixed;
  Color get secondaryFixedDim;
  Color get onSecondaryFixed;
  Color get onSecondaryFixedVariant;

  // Tertiary colors
  Color get tertiary;
  Color get onTertiary;
  Color get tertiaryContainer;
  Color get onTertiaryContainer;
  Color get tertiaryFixed;
  Color get tertiaryFixedDim;
  Color get onTertiaryFixed;
  Color get onTertiaryFixedVariant;

  // Error colors
  Color get error;
  Color get onError;
  Color get errorContainer;
  Color get onErrorContainer;

  // Success colors
  Color get success;
  Color get onSuccess;
  Color get successContainer;
  Color get onSuccessContainer;

  // Warning colors
  Color get warning;
  Color get onWarning;
  Color get warningContainer;
  Color get onWarningContainer;

  // Background & Surface
  Color get background;
  Color get onBackground;
  Color get surface;
  Color get onSurface;
  Color get surfaceDim;
  Color get surfaceBright;
  Color get surfaceContainerLowest;
  Color get surfaceContainerLow;
  Color get surfaceContainer;
  Color get surfaceContainerHigh;
  Color get surfaceContainerHighest;
  Color get surfaceVariant;
  Color get onSurfaceVariant;
  Color get surfaceTint;

  // Outline & Shadow
  Color get outline;
  Color get outlineVariant;
  Color get shadow;
  Color get scrim;

  // Inverse Colors
  Color get inverseSurface;
  Color get onInverseSurface;
  Color get inversePrimary;

  // Additional UI Colors
  Color get selected;
  Color get unSelected;
  Color get disabled;
}
