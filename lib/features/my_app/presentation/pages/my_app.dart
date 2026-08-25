import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/features/my_app/presentation/bloc/my_app_bloc.dart';
import 'package:pashboi/features/my_app/presentation/pages/new_version_required_page.dart';
import 'package:pashboi/features/onboarding/presentation/bloc/onboarding_page_bloc.dart';
import 'package:pashboi/features/landing/presentation/pages/landing_page.dart';
import 'package:pashboi/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pashboi/features/under_maintenance/presentation/pages/under_maintenance_page.dart';
import 'package:pashboi/routes/routes.dart';
import 'package:pashboi/security_gurd.dart';
import 'package:pashboi/shared/widgets/language_switch/bloc/language_switch_bloc.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

import '../../../../core/extensions/global_key.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<OnboardingPageBloc>().add(GetOnboardingSeenEvent());
    context.read<AppStatusBloc>().add(FetchAppStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageSwitchBloc, LanguageSwitchState>(
      builder: (context, languageState) {
        return BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
          builder: (context, themeState) {
            return BlocBuilder<AppStatusBloc, AppStatusState>(
              builder: (context, appStatusState) {
                return BlocBuilder<OnboardingPageBloc, OnboardingPageState>(
                  builder: (context, onboardingState) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      navigatorKey: navigatorKey,
                      scaffoldMessengerKey: rootScaffoldMessengerKey,
                      navigatorObservers: [routeObserver],
                      theme: themeState.themeData,
                      supportedLocales: const [
                        Locale('en', 'US'),
                        Locale('bn', 'BD'),
                      ],
                      localizationsDelegates: Locales.delegates,
                      locale:
                          languageState.language == 'bn'
                              ? const Locale('bn', 'BD')
                              : const Locale('en', 'US'),
                      onGenerateRoute: AppRoutes().onGenerateRoutes,
                      initialRoute: '/',
                      home: UsbDebuggingGuard(
                        child: _buildHome(appStatusState, onboardingState),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHome(
    AppStatusState appStatusState,
    OnboardingPageState onboardingState,
  ) {
    if (appStatusState is AppStatusLoading ||
        appStatusState is AppStatusInitial) {
      return const _LoadingScreen();
    }

    if (appStatusState is UnderMaintenance) {
      return const UnderMaintenancePage();
    }

    if (appStatusState is NewVersionAvailable) {
      return NewVersionRequiredPage(message: appStatusState.message);
    }

    if (appStatusState is AppIsHealthy) {
      if (onboardingState is OnboardingLoading ||
          onboardingState is OnboardingPageInitial) {
        return const _LoadingScreen();
      }

      if (onboardingState is OnboardingSeenLoaded) {
        final bool onboardingSeen = onboardingState.seen;
        return onboardingSeen ? const LandingPage() : const OnboardingPage();
      }
    }

    return const LandingPage();
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
