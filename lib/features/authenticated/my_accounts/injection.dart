import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/datasources/account_util_remote.datasource.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/datasources/deposit_account_remote.datasource.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/repositories/account_util_repository.impl.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/repositories/deposit_account_repository.impl.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/repositories/account_util_repository.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/repositories/deposit_account_repository.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/add_operating_account_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_account_tenure_amounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_account_tenures_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_dependents_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_openable_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_operating_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_account_details_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_account_statement_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_my_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/open_deposit_account_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_details_page/bloc/account_details_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/bloc/account_opening_steps_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_opening_details_section/bloc/tenure_amount_bloc/tenure_amount_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_opening_details_section/bloc/tenure_bloc/tenure_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_statement_page/bloc/account_statement_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/add_operating_account_page/bloc/add_operating_account_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/dependents_page/bloc/fetch_dependents_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/my_account_page/bloc/my_account_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/openable_accounts_page/bloc/openable_account_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/operating_accounts_page/bloc/fetch_operating_accounts_bloc.dart';

void registerMyAccountsModule() async {
  // Register Data Sources
  sl.registerLazySingleton<DepositAccountRemoteDataSource>(
    () => DepositAccountRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  sl.registerLazySingleton<AccountUtilRemoteDataSource>(
    () => AccountUtilRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<DepositAccountRepository>(
    () => DepositAccountRepositoryImpl(
      depositAccountRemoteDataSource: sl<DepositAccountRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<AccountUtilRepository>(
    () => AccountUtilRepositoryImpl(
      accountUtilRemoteDataSource: sl<AccountUtilRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetMyAccountsUseCase>(
    () => GetMyAccountsUseCase(
      depositAccountRepository: sl<DepositAccountRepository>(),
    ),
  );

  sl.registerLazySingleton<GetAccountDetailsUseCase>(
    () => GetAccountDetailsUseCase(
      depositAccountRepository: sl<DepositAccountRepository>(),
    ),
  );

  sl.registerLazySingleton<GetAccountStatementUseCase>(
    () => GetAccountStatementUseCase(
      depositAccountRepository: sl<DepositAccountRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchOperatingAccountsUseCase>(
    () => FetchOperatingAccountsUseCase(
      depositAccountRepository: sl<DepositAccountRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchDependentsUseCase>(
    () => FetchDependentsUseCase(
      depositAccountRepository: sl<DepositAccountRepository>(),
    ),
  );

  sl.registerLazySingleton<AddOperatingAccountUseCase>(
    () => AddOperatingAccountUseCase(
      depositAccountRepository: sl<DepositAccountRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchOpenableAccountsUseCase>(
    () => FetchOpenableAccountsUseCase(
      accountUtilRepository: sl<AccountUtilRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchAccountTenureAmountsUseCase>(
    () => FetchAccountTenureAmountsUseCase(
      accountUtilRepository: sl<AccountUtilRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchAccountTenuresUseCase>(
    () => FetchAccountTenuresUseCase(
      accountUtilRepository: sl<AccountUtilRepository>(),
    ),
  );

  sl.registerLazySingleton<OpenDepositAccountUseCase>(
    () => OpenDepositAccountUseCase(
      depositAccountRepository: sl<DepositAccountRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<AccountOpeningStepsBloc>(
    () => AccountOpeningStepsBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      openDepositAccountUseCase: sl<OpenDepositAccountUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<MyAccountBloc>(
    () => MyAccountBloc(
      getMyAccountsUseCase: sl<GetMyAccountsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<AccountDetailsBloc>(
    () => AccountDetailsBloc(
      getAccountDetailsUseCase: sl<GetAccountDetailsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<AccountStatementBloc>(
    () => AccountStatementBloc(
      getAccountStatementUseCase: sl<GetAccountStatementUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<FetchDependentsBloc>(
    () => FetchDependentsBloc(
      fetchDependentsUseCase: sl<FetchDependentsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<FetchOperatingAccountsBloc>(
    () => FetchOperatingAccountsBloc(
      fetchOperatingAccountUseCase: sl<FetchOperatingAccountsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<AddOperatingAccountBloc>(
    () => AddOperatingAccountBloc(
      addOperatingAccountUseCase: sl<AddOperatingAccountUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<OpenableAccountBloc>(
    () => OpenableAccountBloc(
      fetchOpenableAccountsUseCase: sl<FetchOpenableAccountsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<TenureBloc>(
    () => TenureBloc(
      fetchAccountTenuresUseCase: sl<FetchAccountTenuresUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<TenureAmountBloc>(
    () => TenureAmountBloc(
      fetchAccountTenureAmountsUseCase: sl<FetchAccountTenureAmountsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
