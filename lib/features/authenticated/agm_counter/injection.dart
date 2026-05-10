import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/agm_counter/data/datasources/agm_counter_remote_datasource.dart';
import 'package:pashboi/features/authenticated/agm_counter/data/repositories/agm_counter_repository_impl.dart';
import 'package:pashboi/features/authenticated/agm_counter/domain/repositories/agm_counter_repository.dart';
import 'package:pashboi/features/authenticated/agm_counter/domain/usecases/fetch_agm_counter_info_usecase.dart';
import 'package:pashboi/features/authenticated/agm_counter/presentation/pages/bloc/agm_counter_bloc.dart';

void registerAGMCounterModule() async {
  // Register Data Sources
  sl.registerLazySingleton<AGMCounterRemoteDataSource>(
    () => AGMCounterRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<AGMCounterRepository>(
    () => AGMCounterRepositoryImpl(
      agmCounterRemoteDataSource: sl<AGMCounterRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchAGMCounterInfoUseCase>(
    () => FetchAGMCounterInfoUseCase(
      agmCounterRepository: sl<AGMCounterRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<AgmCounterBloc>(
    () => AgmCounterBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      fetchAgmCounterInfoUseCase: sl<FetchAGMCounterInfoUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
