import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/loan_policies/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/loan_policies/data/repositories/loan_policy_repository_impl.dart';
import 'package:pashboi/features/public/loan_policies/domain/repositories/loan_policy_repository.dart';
import 'package:pashboi/features/public/loan_policies/domain/usecases/fetch_loan_policy_usecase.dart';
import 'package:pashboi/features/public/loan_policies/presentation/bloc/loan_policy_bloc.dart';

void registerLoanPolicyModule() async {
  // Register Data Sources
  sl.registerLazySingleton<LoanPolicyRemoteDataSource>(
    () => LoanPolicyRemoteDataSourceImpl(
      productApiService: sl<ProductApiService>(),
    ),
  );

  // Register Repository
  sl.registerLazySingleton<LoanPolicyRepository>(
    () => LoanPolicyRepositoryImpl(
      loanPolicyRemoteDataSource: sl<LoanPolicyRemoteDataSource>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchLoanPolicyUseCase>(
    () => FetchLoanPolicyUseCase(
      loanPolicyRepository: sl<LoanPolicyRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<LoanPolicyBloc>(
    () => LoanPolicyBloc(fetchLoanPolicyUseCase: sl<FetchLoanPolicyUseCase>()),
  );
}
