import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/loan_payment/data/datasources/loan_payment_remote_datasource.dart';
import 'package:pashboi/features/authenticated/loan_payment/data/repositories/loan_payment_repository_impl.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/repositories/loan_payment_repository.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/usecases/fetch_loan_payment_usecase.dart';
import 'package:pashboi/features/authenticated/loan_payment/presentation/pages/bloc/loan_payment_bloc.dart';

void registerLoanPaymentModule() async {
  // Register Data Sources
  sl.registerLazySingleton<LoanPaymentRemoteDataSource>(
    () => LoanPaymentRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<LoanPaymentRepository>(
    () => LoanPaymentRepositoryImpl(
      loanPaymentRemoteDataSource: sl<LoanPaymentRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchLoanPaymentUseCase>(
    () => FetchLoanPaymentUseCase(
      loanPaymentRepository: sl<LoanPaymentRepository>(),
    ),
  );

  // Register Bloc

  sl.registerFactory<LoanPaymentBloc>(
    () => LoanPaymentBloc(
      fetchLoanPaymentUseCase: sl<FetchLoanPaymentUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
