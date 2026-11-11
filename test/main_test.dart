import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/family_and_relatives_bloc/family_and_relatives_bloc.dart';
import 'package:pashboi/features/landing/presentation/bloc/advertisement_bloc.dart';
import 'package:pashboi/features/my_app/presentation/bloc/my_app_bloc.dart';
import 'package:pashboi/features/onboarding/presentation/bloc/onboarding_page_bloc.dart';
import 'package:pashboi/main.dart' as app;
import 'package:pashboi/shared/widgets/language_switch/bloc/language_switch_bloc.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

class _MockLanguageSwitchBloc
    extends MockBloc<LanguageSwitchEvent, LanguageSwitchState>
    implements LanguageSwitchBloc {}

class _MockThemeSelectorBloc
    extends MockBloc<ThemeSelectorEvent, ThemeSelectorState>
    implements ThemeSelectorBloc {}

class _FakeLanguageSwitchEvent extends Fake implements LanguageSwitchEvent {}

class _FakeThemeSelectorEvent extends Fake implements ThemeSelectorEvent {}

class _AppProviderProbe extends StatelessWidget {
  const _AppProviderProbe();

  @override
  Widget build(BuildContext context) {
    context.read<LanguageSwitchBloc>();
    context.read<ThemeSelectorBloc>();
    return const MaterialApp(home: Text('App providers are ready'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final locator = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(_FakeLanguageSwitchEvent());
    registerFallbackValue(_FakeThemeSelectorEvent());
  });

  late _MockLanguageSwitchBloc languageSwitchBloc;
  late _MockThemeSelectorBloc themeSelectorBloc;

  setUp(() async {
    await locator.reset();
    languageSwitchBloc = _MockLanguageSwitchBloc();
    themeSelectorBloc = _MockThemeSelectorBloc();

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

    locator.registerFactory<LanguageSwitchBloc>(() => languageSwitchBloc);
    locator.registerFactory<ThemeSelectorBloc>(() => themeSelectorBloc);
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('provides app-wide blocs and loads saved preferences', (
    tester,
  ) async {
    await tester.pumpWidget(
      app.createPashboiApp(child: const _AppProviderProbe()),
    );

    expect(find.text('App providers are ready'), findsOneWidget);
    expect(find.byType(BlocProvider<LanguageSwitchBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<ThemeSelectorBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<OnboardingPageBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<AppStatusBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<AuthBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<DebitCardBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<BeneficiariesBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<FamilyAndRelativesBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<CollectionLedgerBloc>), findsOneWidget);
    expect(find.byType(BlocProvider<AdvertisementBloc>), findsOneWidget);

    final localeEvents =
        verify(() => languageSwitchBloc.add(captureAny())).captured;
    final themeEvents =
        verify(() => themeSelectorBloc.add(captureAny())).captured;
    expect(localeEvents, hasLength(1));
    expect(localeEvents.single, isA<LoadLocaleEvent>());
    expect(themeEvents, hasLength(1));
    expect(themeEvents.single, isA<LoadTheme>());
    expect(tester.takeException(), isNull);
  });
}
