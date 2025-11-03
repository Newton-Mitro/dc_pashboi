import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';

class SubmitInstantLoansProps extends BaseRequestProps {
  final String nameOnCard;
  final String otpRegId;
  final String otpValue;
  final String secretKey;
  final String cardNo;
  final String accountNo;
  final String appliedAmount;
  final bool isTopUp;

  const SubmitInstantLoansProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.nameOnCard,
    required this.secretKey,
    required this.cardNo,
    required this.accountNo,
    required this.appliedAmount,
    required this.otpRegId,
    required this.otpValue,
    required this.isTopUp,
  });
}

class SubmitInstantLoansUseCase
    extends UseCase<String, SubmitInstantLoansProps> {
  final LoanRepository loanRepository;

  SubmitInstantLoansUseCase({required this.loanRepository});

  @override
  ResultFuture<String> call(SubmitInstantLoansProps props) async {
    return loanRepository.submitInstantLoans(props);
  }
}
