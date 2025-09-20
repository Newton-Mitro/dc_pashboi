import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/utils/app_bloc_observer.dart';
import 'package:pashboi/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/mobile_number_verification_bloc/mobile_number_verification_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/otp_verification_bloc/otp_verification_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/family_and_relatives_bloc/family_and_relatives_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/relationship_bloc/relationship_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/dependents_page/bloc/fetch_dependents_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/my_account_page/bloc/my_account_bloc.dart';
import 'package:pashboi/features/authenticated/profile/presentation/change_password/bloc/change_password_bloc.dart';
import 'package:pashboi/features/my_app/presentation/bloc/my_app_bloc.dart';
import 'package:pashboi/features/onboarding/presentation/bloc/onboarding_page_bloc.dart';
import 'package:pashboi/features/terms_and_condition/presentation/pages/bloc/term_and_condition_bloc.dart';
import 'package:pashboi/injection.dart';
import 'package:pashboi/features/my_app/presentation/pages/my_app.dart';
import 'package:pashboi/shared/widgets/language_switch/bloc/language_switch_bloc.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Locales.init(['en', 'bn']);
  Bloc.observer = AppBlocObserver();
  await dotenv.load(fileName: ".env");

  await setupDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LanguageSwitchBloc>()..add(LoadLocaleEvent()),
        ),
        BlocProvider(create: (_) => sl<ThemeSelectorBloc>()..add(LoadTheme())),
        BlocProvider(create: (_) => sl<OnboardingPageBloc>()),
        BlocProvider(create: (_) => sl<AppStatusBloc>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<VerifyMobileNumberBloc>()),
        BlocProvider(create: (_) => sl<OtpVerificationBloc>()),
        BlocProvider(create: (_) => sl<ResetPasswordBloc>()),
        BlocProvider(create: (context) => sl<DebitCardBloc>()),
        BlocProvider(create: (context) => sl<FetchDependentsBloc>()),
        BlocProvider(create: (context) => sl<BeneficiariesBloc>()),
        BlocProvider(create: (context) => sl<FamilyAndRelativesBloc>()),
        BlocProvider(create: (context) => sl<RelationshipBloc>()),
        BlocProvider(create: (context) => sl<CollectionLedgerBloc>()),
        BlocProvider(create: (context) => sl<MyAccountBloc>()),
        BlocProvider(create: (context) => sl<ChangePasswordBloc>()),
        BlocProvider(create: (context) => sl<TermAndConditionBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
