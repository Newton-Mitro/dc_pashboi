import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/instant_loan_eligibility_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class InstantLoanEligibilityProps extends BaseRequestProps {
  const InstantLoanEligibilityProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class InstantLoanEligibilityUseCase
    extends UseCase<InstantLoanEligibilityDTO, InstantLoanEligibilityProps> {
  final LoanRepository loanRepository;

  InstantLoanEligibilityUseCase({required this.loanRepository});

  @override
  ResultFuture<InstantLoanEligibilityDTO> call(
    InstantLoanEligibilityProps props,
  ) async {
    return loanRepository.instantLoanEligibility(props);
  }
}
