import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/my_loans/data/repositories/loan_repository.impl.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/check_instant_loan_eligibility_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/deposit_loan_eligibility_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_against_loan_interest_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_details_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_statement_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_product_loan_collateral%20_account_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_instant_loan_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_loan_against_deposit_product_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_application_page/instant_loan_eligible/bloc/instant_loan_eligible_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_terms_condition_page/bloc/instant_loan_eligibility_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/loan_details_page/bloc/loan_details_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/loan_statement_section/bloc/loan_statement_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/my_loans_page/bloc/my_loans_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/bloc/deposit_product_loan_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/deposit_loan_product_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/product_loan_collection_account_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/step/bloc/fetch_against_loan_interest_bloc.dart';

void registerLoanModule() async {
  // Register Data Sources
  sl.registerLazySingleton<LoanRemoteDataSource>(
    () => LoanRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<LoanRepository>(
    () => LoanRepositoryImpl(
      loanRemoteDataSource: sl<LoanRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchMyLoansUseCase>(
    () => FetchMyLoansUseCase(loanRepository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<FetchLoanStatementUseCase>(
    () => FetchLoanStatementUseCase(loanRepository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<FetchLoanDetailsUseCase>(
    () => FetchLoanDetailsUseCase(loanRepository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<InstantLoanEligibilityUseCase>(
    () => InstantLoanEligibilityUseCase(loanRepository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<SubmitInstantLoansUseCase>(
    () => SubmitInstantLoansUseCase(loanRepository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<FetchDepositLoanUseCase>(
    () => FetchDepositLoanUseCase(loanRepository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<FetchProductLoanCollateralAccountUseCase>(
    () => FetchProductLoanCollateralAccountUseCase(
      loanRepository: sl<LoanRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchAgainstLoanInterestUseCase>(
    () => FetchAgainstLoanInterestUseCase(loanRepository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<SubmitLoanAgainstDepositProductUseCase>(
    () => SubmitLoanAgainstDepositProductUseCase(
      loanRepository: sl<LoanRepository>(),
    ),
  );
  // Register Bloc
  sl.registerFactory<MyLoansBloc>(
    () => MyLoansBloc(
      fetchMyLoansUseCase: sl<FetchMyLoansUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<LoanDetsilsBloc>(
    () => LoanDetsilsBloc(
      fetchLoanDetailsUseCase: sl<FetchLoanDetailsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<LoanStatementBloc>(
    () => LoanStatementBloc(
      fetchLoanStatementUseCase: sl<FetchLoanStatementUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<InstantLoanEligibilityBloc>(
    () => InstantLoanEligibilityBloc(
      instantLoanEligibilityUseCase: sl<InstantLoanEligibilityUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<InstantLoanEligibleBloc>(
    () => InstantLoanEligibleBloc(
      submitInstantLoansUseCase: sl<SubmitInstantLoansUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<DepositProductLoanBloc>(
    () => DepositProductLoanBloc(
      fetchDepositLoanUseCase: sl<FetchDepositLoanUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<DepositLoanProductBloc>(
    () => DepositLoanProductBloc(
      submitLoanAgainstDepositProductUseCase:
          sl<SubmitLoanAgainstDepositProductUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<ProductLoanCollectionAccountBloc>(
    () => ProductLoanCollectionAccountBloc(
      fetchProductLoanCollateralAccountUseCase:
          sl<FetchProductLoanCollateralAccountUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );

  sl.registerFactory<FetchAgainstLoanInterestBloc>(
    () => FetchAgainstLoanInterestBloc(
      fetchAgainstLoanInterestUseCase: sl<FetchAgainstLoanInterestUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
    ),
  );
}
