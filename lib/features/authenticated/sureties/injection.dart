import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/sureties/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/sureties/data/repositories/surety_repository.impl.dart';
import 'package:pashboi/features/authenticated/sureties/domain/repositories/surety_repository.dart';
import 'package:pashboi/features/authenticated/sureties/domain/usecases/fetch_given_sureties_usecase.dart';
import 'package:pashboi/features/authenticated/sureties/domain/usecases/fetch_loan_sureties_usecase.dart';
import 'package:pashboi/features/authenticated/sureties/presentation/pages/bloc/surety_bloc.dart';

void registerSuretyModule() async {
  // Register Data Sources
  sl.registerLazySingleton<SuretyRemoteDataSource>(
    () => SuretyRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<SuretyRepository>(
    () => SuretyRepositoryImpl(
      suretyRemoteDataSource: sl<SuretyRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchGivenSuretiesUseCase>(
    () => FetchGivenSuretiesUseCase(suretyRepository: sl<SuretyRepository>()),
  );
  sl.registerLazySingleton<FetchLoanSuretiesUseCase>(
    () => FetchLoanSuretiesUseCase(suretyRepository: sl<SuretyRepository>()),
  );
  // Register Bloc
  sl.registerFactory<SuretyBloc>(
    () => SuretyBloc(
      fetchGivenSuretiesUseCase: sl<FetchGivenSuretiesUseCase>(),
      fetchLoanSuretiesUseCase: sl<FetchLoanSuretiesUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
