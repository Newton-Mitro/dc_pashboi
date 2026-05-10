import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/withdraw/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/withdraw/data/repositories/withdrawl_repository.impl.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/repositories/withdrawl_repository.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/usecases/generate_withdrawl_qr_usecase.dart';
import 'package:pashboi/features/authenticated/withdraw/presentation/pages/withdrawl_qr_page/bloc/withdrawl_qr_steps_bloc.dart';

void registerWithdrawlModule() async {
  // Register Data Sources
  sl.registerLazySingleton<WithdrawlRemoteDataSource>(
    () => WithdrawlRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<WithdrawlRepository>(
    () => WithdrawlRepositoryImpl(
      withdrawlRemoteDataSource: sl<WithdrawlRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GenerateWithdrawlQrUseCase>(
    () => GenerateWithdrawlQrUseCase(
      withdrawlRepository: sl<WithdrawlRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<WithdrawlQrStepsBloc>(
    () => WithdrawlQrStepsBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      generateWithdrawlQrUseCase: sl<GenerateWithdrawlQrUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
