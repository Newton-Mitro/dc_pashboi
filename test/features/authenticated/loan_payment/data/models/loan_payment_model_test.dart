import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/loan_payment/data/models/loan_payment_model.dart';

void main() {
  test('maps loan repayment fields and serializes them', () {
    final model = LoanPaymentModel.fromJson({
      'id': 5,
      'LoanNumber': 'LN-205',
      'LoanRefundAmount': 12500,
      'InterestAmount': 420,
      'LoanFine': 25,
      'LoanLpsAmount': 500,
      'LoanLpsRenewFeeAmount': 75,
      'ShareFine': 10,
    });

    expect(model.id, 5);
    expect(model.loanNumber, 'LN-205');
    expect(model.loanRefundAmount, 12500);
    expect(model.interestAmount, 420);
    expect(model.loanFineAmount, 25);
    expect(model.loanLpsAmount, 500);
    expect(model.loanLpsRenewalFeeAmount, 75);
    expect(model.shareFineAmount, 10);
    expect(model.toJson(), {
      'id': 5,
      'LoanNumber': 'LN-205',
      'LoanRefundAmount': 12500,
      'InterestAmount': 420,
      'LoanFine': 25,
      'LoanLpsAmount': 500,
      'LoanLpsRenewFeeAmount': 75,
      'ShareFine': 10,
    });
  });

  test('defaults absent repayment fields', () {
    final model = LoanPaymentModel.fromJson({});

    expect(model.loanNumber, isEmpty);
    expect(model.loanRefundAmount, 0.0);
    expect(model.interestAmount, 0.0);
    expect(model.loanFineAmount, 0.0);
    expect(model.loanLpsAmount, 0.0);
    expect(model.loanLpsRenewalFeeAmount, 0.0);
    expect(model.shareFineAmount, 0.0);
  });
}
