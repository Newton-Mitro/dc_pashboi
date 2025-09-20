import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/against_loan_interest_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class FetchAgainstLoanInterestProps extends BaseRequestProps {
  final String productCode;
  final String accountIds;

  const FetchAgainstLoanInterestProps({
    required this.productCode,
    required this.accountIds,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FetchAgainstLoanInterestUseCase
    extends UseCase<AgainstLoanInterestEntity, FetchAgainstLoanInterestProps> {
  final LoanRepository loanRepository;

  FetchAgainstLoanInterestUseCase({required this.loanRepository});

  @override
  ResultFuture<AgainstLoanInterestEntity> call(
    FetchAgainstLoanInterestProps props,
  ) async {
    return loanRepository.fetchAgainstLoanInterest(props);
  }
}
