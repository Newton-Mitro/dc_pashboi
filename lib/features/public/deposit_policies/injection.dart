import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/deposit_policies/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/deposit_policies/data/repositories/deposit_policy_repository_impl.dart';
import 'package:pashboi/features/public/deposit_policies/domain/repositories/deposit_policy_repository.dart';
import 'package:pashboi/features/public/deposit_policies/domain/usecases/fetch_deposit_policy_usecase.dart';
import 'package:pashboi/features/public/deposit_policies/presentation/bloc/deposit_policy_bloc.dart';

void registerDepositPolicyModule() {
  // Register Data Sources
  sl.registerLazySingleton<DepositPolicyRemoteDataSource>(
    () => DepositPolicyRemoteDataSourceImpl(
      productApiService: sl<ProductApiService>(),
    ),
  );

  // Register Repository
  sl.registerLazySingleton<DepositPolicyRepository>(
    () => DepositPolicyRepositoryImpl(
      depositPolicyRemoteDataSource: sl<DepositPolicyRemoteDataSource>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchDepositPolicyUseCase>(
    () => FetchDepositPolicyUseCase(
      depositPolicyRepository: sl<DepositPolicyRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<DepositPolicyBloc>(
    () => DepositPolicyBloc(
      fetchDepositPolicyUseCase: sl<FetchDepositPolicyUseCase>(),
    ),
  );
}
