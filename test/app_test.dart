import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pashboi/features/my_app/presentation/bloc/my_app_bloc.dart';
import 'package:pashboi/features/my_app/presentation/pages/my_app.dart';
import 'package:pashboi/features/onboarding/presentation/bloc/onboarding_page_bloc.dart';
import 'package:pashboi/shared/widgets/language_switch/bloc/language_switch_bloc.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

class _MockAppStatusBloc extends MockBloc<AppStatusEvent, AppStatusState>
    implements AppStatusBloc {}

class _MockOnboardingBloc
    extends MockBloc<OnboardingPageEvent, OnboardingPageState>
    implements OnboardingPageBloc {}

class _MockLanguageSwitchBloc
    extends MockBloc<LanguageSwitchEvent, LanguageSwitchState>
    implements LanguageSwitchBloc {}

class _MockThemeSelectorBloc
    extends MockBloc<ThemeSelectorEvent, ThemeSelectorState>
    implements ThemeSelectorBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late _MockAppStatusBloc appStatusBloc;
  late _MockOnboardingBloc onboardingBloc;
  late _MockLanguageSwitchBloc languageSwitchBloc;
  late _MockThemeSelectorBloc themeSelectorBloc;

  setUp(() {
    appStatusBloc = _MockAppStatusBloc();
    onboardingBloc = _MockOnboardingBloc();
    languageSwitchBloc = _MockLanguageSwitchBloc();
    themeSelectorBloc = _MockThemeSelectorBloc();

    whenListen(
      appStatusBloc,
      const Stream<AppStatusState>.empty(),
      initialState: const AppStatusLoading(),
    );
    whenListen(
      onboardingBloc,
      const Stream<OnboardingPageState>.empty(),
      initialState: const OnboardingPageInitial(),
    );
    whenListen(
      languageSwitchBloc,
      const Stream<LanguageSwitchState>.empty(),
      initialState: const LanguageSwitchState(language: 'en'),
    );
    whenListen(
      themeSelectorBloc,
      const Stream<ThemeSelectorState>.empty(),
      initialState: BlueOceanTheme(),
    );
  });

  tearDown(() async {
    await appStatusBloc.close();
    await onboardingBloc.close();
    await languageSwitchBloc.close();
    await themeSelectorBloc.close();
  });

  testWidgets('boots app shell and renders initial loading state', (
    tester,
  ) async {
    await Locales.init(['en', 'bn']);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppStatusBloc>.value(value: appStatusBloc),
          BlocProvider<OnboardingPageBloc>.value(value: onboardingBloc),
          BlocProvider<LanguageSwitchBloc>.value(value: languageSwitchBloc),
          BlocProvider<ThemeSelectorBloc>.value(value: themeSelectorBloc),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
