import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class AppLocalizationService {
  final GlobalKey<NavigatorState> navigatorKey;

  AppLocalizationService(this.navigatorKey);

  /// Current context from navigator
  BuildContext? get context => navigatorKey.currentContext;

  /// Translate key safely
  String t(String key) {
    final ctx = context;
    if (ctx == null) return key; // fallback safety
    return Locales.string(ctx, key);
  }

  /// Change locale
  Future<void> changeLocale(Locale locale) async {
    await Locales.change(context!, locale.languageCode);
  }

  Locale get currentLocale =>
      Localizations.localeOf(context ?? navigatorKey.currentContext!);
}
