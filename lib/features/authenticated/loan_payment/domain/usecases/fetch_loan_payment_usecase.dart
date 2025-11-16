import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/entities/loan_payment_entity.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/repositories/loan_payment_repository.dart';

class FetchLoanPaymentProps extends BaseRequestProps {
  final String loanNumber;
  final int interestDays;
  final double interestRate;
  final int loanBalance;
  final int loanRefundAmount;
  final String moduleCode;
  final String? issuedDate;
  final String? lastPaidDate;

  const FetchLoanPaymentProps({
    required this.loanNumber,
    required this.interestDays,
    required this.interestRate,
    required this.loanBalance,
    required this.loanRefundAmount,
    required this.moduleCode,
    required this.issuedDate,
    required this.lastPaidDate,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FetchLoanPaymentUseCase
    extends UseCase<LoanPaymentEntity, FetchLoanPaymentProps> {
  final LoanPaymentRepository loanPaymentRepository;

  FetchLoanPaymentUseCase({required this.loanPaymentRepository});

  @override
  ResultFuture<LoanPaymentEntity> call(FetchLoanPaymentProps props) async {
    return loanPaymentRepository.fetchLoanPayment(props);
  }
}
