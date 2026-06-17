import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/deposit/data/repositories/deposit_repository.impl.dart';
import 'package:pashboi/features/authenticated/deposit/domain/repositories/deposit_repository.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/fetch_bkash_service_charge_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/fetch_scheduled_deposits_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_from_bkash_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_later_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_now_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_from_bkash_page/bloc/deposit_from_bkash_steps_bloc.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_from_bkash_page/parts/transaction_charge_preview_section/bloc/bkash_service_charge_bloc.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_later_page/bloc/deposit_later_steps_bloc.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_now_page/bloc/deposit_now_steps_bloc.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/scheduled_deposits_page/bloc/scheduled_deposits_bloc.dart';

void registerDepositModule() async {
  // Register Data Sources
  sl.registerLazySingleton<DepositRemoteDataSource>(
    () => DepositRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // sl.registerLazySingleton<DepositRemoteDataSource>(
  //   () => MockDepositRemoteDataSource(),
  // );

  // Register Repository
  sl.registerLazySingleton<DepositRepository>(
    () => DepositRepositoryImpl(
      depositRemoteDataSource: sl<DepositRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<SubmitDepositNowUseCase>(
    () => SubmitDepositNowUseCase(depositRepository: sl<DepositRepository>()),
  );
  sl.registerLazySingleton<SubmitDepositLaterUseCase>(
    () => SubmitDepositLaterUseCase(depositRepository: sl<DepositRepository>()),
  );
  sl.registerLazySingleton<SubmitDepositFromBkashUseCase>(
    () => SubmitDepositFromBkashUseCase(
      depositRepository: sl<DepositRepository>(),
    ),
  );
  sl.registerLazySingleton<FetchBkashServiceChargeUseCase>(
    () => FetchBkashServiceChargeUseCase(
      depositRepository: sl<DepositRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchScheduledDepositsUseCase>(
    () => FetchScheduledDepositsUseCase(
      depositRepository: sl<DepositRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<DepositNowStepsBloc>(
    () => DepositNowStepsBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      submitDepositNowUseCase: sl<SubmitDepositNowUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
  sl.registerFactory<DepositLaterStepsBloc>(
    () => DepositLaterStepsBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      submitDepositLaterUseCase: sl<SubmitDepositLaterUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
  sl.registerFactory<DepositFromBkashStepsBloc>(
    () => DepositFromBkashStepsBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      submitDepositFromBkashUseCase: sl<SubmitDepositFromBkashUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
  sl.registerFactory<BkashServiceChargeBloc>(
    () => BkashServiceChargeBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      fetchBkashServiceChargeUseCase: sl<FetchBkashServiceChargeUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
  sl.registerFactory<ScheduledDepositsBloc>(
    () => ScheduledDepositsBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      fetchScheduledDepositsUseCase: sl<FetchScheduledDepositsUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
