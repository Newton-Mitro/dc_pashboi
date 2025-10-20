import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/deposit_loan_eligibility_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class DepositLoanEligibilityProps extends BaseRequestProps {
  const DepositLoanEligibilityProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FetchDepositLoanUseCase
    extends
        UseCase<List<DepositLoanEligibilityDto>, DepositLoanEligibilityProps> {
  final LoanRepository loanRepository;

  FetchDepositLoanUseCase({required this.loanRepository});

  @override
  ResultFuture<List<DepositLoanEligibilityDto>> call(
    DepositLoanEligibilityProps props,
  ) async {
    return loanRepository.fetchDepositLoan(props);
  }
}
