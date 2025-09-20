import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/terms_and_condition/data/datasources/term_and_condition_remote_datasource.dart';
import 'package:pashboi/features/terms_and_condition/data/repositories/term_and_condition_repository_impl.dart';
import 'package:pashboi/features/terms_and_condition/domain/repositories/term_and_condition_repository.dart';
import 'package:pashboi/features/terms_and_condition/domain/usecases/fetch_term_and_condition_usecase.dart';
import 'package:pashboi/features/terms_and_condition/presentation/pages/bloc/term_and_condition_bloc.dart';

void registerTermAndConditionModule() async {
  // Register Data Sources
  sl.registerLazySingleton<TermAndConditionRemoteDataSource>(
    () => TermAndConditionRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<TermAndConditionRepository>(
    () => TermAndConditionRepositoryImpl(
      termAndConditionRemoteDataSource: sl<TermAndConditionRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchTermAndConditionUseCase>(
    () => FetchTermAndConditionUseCase(
      termAndConditionRepository: sl<TermAndConditionRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<TermAndConditionBloc>(
    () => TermAndConditionBloc(
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      fetchTermAndConditionUseCase: sl<FetchTermAndConditionUseCase>(),
    ),
  );
}
