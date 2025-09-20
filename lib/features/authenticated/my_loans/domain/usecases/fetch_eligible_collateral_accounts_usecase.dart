import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/collateral_info_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class FetchEligibleCollateralAccountsProps extends BaseRequestProps {
  final String productCode;

  const FetchEligibleCollateralAccountsProps({
    required this.productCode,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FetchEligibleCollateralAccountsUseCase
    extends
        UseCase<CollateralInfoEntity, FetchEligibleCollateralAccountsProps> {
  final LoanRepository loanRepository;

  FetchEligibleCollateralAccountsUseCase({required this.loanRepository});

  @override
  ResultFuture<CollateralInfoEntity> call(
    FetchEligibleCollateralAccountsProps props,
  ) async {
    return loanRepository.fetchEligibleCollateralAccounts(props);
  }
}
