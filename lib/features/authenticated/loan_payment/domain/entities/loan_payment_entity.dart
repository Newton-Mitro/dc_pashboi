import 'package:pashboi/core/entities/entity.dart';

class LoanPaymentEntity extends Entity<int> {
  final String loanNumber;
  final int loanRefundAmount;
  final int interestAmount;
  final int loanFineAmount;
  final int loanLpsAmount;
  final int loanLpsRenewalFeeAmount;
  final int shareFineAmount;

  LoanPaymentEntity({
    super.id,
    required this.loanNumber,
    required this.loanRefundAmount,
    required this.interestAmount,
    required this.loanFineAmount,
    required this.loanLpsAmount,
    required this.loanLpsRenewalFeeAmount,
    required this.shareFineAmount,
  });

  @override
  List<Object?> get props => [
    id,
    loanNumber,
    loanRefundAmount,
    interestAmount,
    loanFineAmount,
    loanLpsAmount,
    loanLpsRenewalFeeAmount,
    shareFineAmount,
  ];
}
