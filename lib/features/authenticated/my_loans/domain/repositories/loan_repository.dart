import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/against_loan_interest_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/collateral_info_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_product_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_transaction_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_against_loan_interest_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_collateral_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_details_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_statement_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_loan_products_usecase.dart';

abstract class LoanRepository {
  ResultFuture<List<LoanAccountEntity>> fetchMyLoans(FetchMyLoansProps props);
  ResultFuture<LoanAccountEntity> fetchLoanDetails(FetchLoanDetailsProps props);
  // ResultFuture<String> createInstantLoanAccount(LoanAccountEntity loanAccount);
  // ResultFuture<String> createProductLoanAccount(LoanAccountEntity loanAccount);
  ResultFuture<List<LoanTransactionEntity>> fetchLoanStatement(
    FetchLoanStatementProps props,
  );
  ResultFuture<CollateralInfoEntity> fetchEligibleCollateralAccounts(
    FetchEligibleCollateralAccountsProps props,
  );
  ResultFuture<List<LoanProductEntity>> fetchEligibleLoanProducts(
    FetchEligibleLoanProductsProps props,
  );
  ResultFuture<AgainstLoanInterestEntity> fetchAgainstLoanInterest(
    FetchAgainstLoanInterestProps props,
  );
}
