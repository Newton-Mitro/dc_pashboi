import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/logging/logger_service.dart';
import 'package:pashboi/core/services/logging/logger_service_impl.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/services/network/network_info_impl.dart';
import 'package:pashboi/core/services/local_storage/local_storage.dart';
import 'package:pashboi/core/services/local_storage/local_storage_impl.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:pashboi/shared/widgets/language_switch/bloc/language_switch_bloc.dart';
import 'package:pashboi/core/locale/services/locale_service.dart';
import 'package:pashboi/core/locale/services/locale_service_impl.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';
import 'package:pashboi/core/theme/services/theme_service.dart';
import 'package:pashboi/core/theme/services/theme_service_impl.dart';
import 'services/network/api_service.dart';

final sl = GetIt.instance;

// Global navigator key (important)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> registerCoreServices() async {
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<LocalStorage>(() => LocalStorageImpl());
  sl.registerLazySingleton<ApiService>(
    () => ApiService(
      authLocalDataSource: sl<AuthLocalDataSource>(),
      loggerService: sl<LoggerService>(),
    ),
  );

  sl.registerLazySingleton<ProductApiService>(
    () => ProductApiService(loggerService: sl<LoggerService>()),
  );

  // ✅ Logging Service
  sl.registerLazySingleton<LoggerService>(() => LoggerServiceImpl());
  sl.registerLazySingleton<AppLocalizationService>(
    () => AppLocalizationService(navigatorKey),
  );
  sl.registerLazySingleton<LocaleService>(
    () => LocaleServiceImpl(sl<LocalStorage>()),
  );
  sl.registerLazySingleton<ThemeService>(
    () => ThemeServiceImpl(sl<LocalStorage>()),
  );

  // ✅ Network Info (Detects Internet Connectivity)
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl<Connectivity>()),
  );

  // Register Bloc
  sl.registerFactory<LanguageSwitchBloc>(
    () => LanguageSwitchBloc(localeService: sl<LocaleService>()),
  );

  sl.registerFactory<ThemeSelectorBloc>(
    () => ThemeSelectorBloc(themeService: sl<ThemeService>()),
  );
}
