import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/against_loan_interest_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/deposit_loan_eligibility_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_accounts_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/instant_loan_eligibility_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/collateral_info_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_product_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_transaction_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/check_instant_loan_eligibility_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/deposit_loan_eligibility_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_against_loan_interest_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_collateral_accounts_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_details_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_statement_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_eligible_loan_products_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_product_loan_collateral%20_account_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_instant_loan_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_loan_against_deposit_product_usecase.dart';

abstract class LoanRepository {
  ResultFuture<List<LoanAccountEntity>> fetchMyLoans(FetchMyLoansProps props);
  ResultFuture<LoanAccountEntity> fetchLoanDetails(FetchLoanDetailsProps props);

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

  ResultFuture<InstantLoanEligibilityDTO> instantLoanEligibility(
    InstantLoanEligibilityProps props,
  );

  ResultFuture<String> submitInstantLoans(SubmitInstantLoansProps props);

  ResultFuture<List<DepositLoanEligibilityDto>> fetchDepositLoan(
    DepositLoanEligibilityProps props,
  );

  ResultFuture<ProductLoanEligibleCollateralAccountDto>
  fetchProductLoanCollateralAccount(
    FetchProductLoanCollateralAccountProps props,
  );

  ResultFuture<String> submitLoanAgainstDepositProduct(
    SubmitLoanAgainstDepositProductProps props,
  );
}
