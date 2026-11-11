import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_accounts_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class FetchProductLoanCollateralAccountProps extends BaseRequestProps {
  final String productCode;

  const FetchProductLoanCollateralAccountProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.productCode,
  });
}

class FetchProductLoanCollateralAccountUseCase
    extends
        UseCase<
          ProductLoanEligibleCollateralAccountDto,
          FetchProductLoanCollateralAccountProps
        > {
  final LoanRepository loanRepository;

  FetchProductLoanCollateralAccountUseCase({required this.loanRepository});

  @override
  ResultFuture<ProductLoanEligibleCollateralAccountDto> call(
    FetchProductLoanCollateralAccountProps props,
  ) async {
    return loanRepository.fetchProductLoanCollateralAccount(props);
  }
}
