import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/service/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/service/data/repositories/service_policy_repository_impl.dart';
import 'package:pashboi/features/public/service/domain/repositories/service_policy_repository.dart';
import 'package:pashboi/features/public/service/domain/usecases/fetch_service_policy_usecase.dart';
import 'package:pashboi/features/public/service/presentation/bloc/service_policy_bloc.dart';

void registerServicePolicyModule() async {
  // Register Data Sources
  sl.registerLazySingleton<ServicePolicyRemoteDataSource>(
    () => ServicePolicyRemoteDataSourceImpl(
      productApiService: sl<ProductApiService>(),
    ),
  );

  sl.registerLazySingleton<ServicePolicyRepository>(
    () => ServicePolicyRepositoryImpl(
      servicePolicyRemoteDataSource: sl<ServicePolicyRemoteDataSource>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchServicePolicyUseCase>(
    () => FetchServicePolicyUseCase(
      servicePolicyRepository: sl<ServicePolicyRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<ServicePolicyBloc>(
    () => ServicePolicyBloc(
      fetchServicePolicyUseCase: sl<FetchServicePolicyUseCase>(),
    ),
  );
}
