import 'package:pashboi/features/authenticated/loan_payment/domain/entities/loan_payment_entity.dart';

class LoanPaymentModel extends LoanPaymentEntity {
  LoanPaymentModel({
    required super.id,
    required super.loanNumber,
    required super.loanRefundAmount,
    required super.interestAmount,
    required super.loanFineAmount,
    required super.loanLpsAmount,
    required super.loanLpsRenewalFeeAmount,
    required super.shareFineAmount,
  });

  factory LoanPaymentModel.fromJson(Map<String, dynamic> json) {
    return LoanPaymentModel(
      id: json['id'] ?? 0,
      loanNumber: json['LoanNumber'] ?? '',
      loanRefundAmount: json['LoanRefundAmount'] ?? 0,
      interestAmount: json['InterestAmount'] ?? 0,
      loanFineAmount: json['LoanFine'] ?? 0,
      loanLpsAmount: json['LoanLpsAmount'] ?? 0,
      loanLpsRenewalFeeAmount: json['LoanLpsRenewFeeAmount'] ?? 0,
      shareFineAmount: json['ShareFine'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'LoanNumber': loanNumber,
      'LoanRefundAmount': loanRefundAmount,
      'InterestAmount': interestAmount,
      'LoanFine': loanFineAmount,
      'LoanLpsAmount': loanLpsAmount,
      'LoanLpsRenewFeeAmount': loanLpsRenewalFeeAmount,
      'ShareFine': shareFineAmount,
    };
  }
}
