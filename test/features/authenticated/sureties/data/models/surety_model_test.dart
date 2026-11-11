import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/sureties/data/models/surety_model.dart';

void main() {
  test('maps surety loan, member, balance, and status details', () {
    final model = SuretyModel.fromJson({
      'id': 8,
      'LoanId': 'LN-108',
      'LoanOpenDate': '2024-01-10T00:00:00.000',
      'MemberAccount': 'SA-80',
      'MemberName': 'Surety Member',
      'MemberMobileNo': '01700000080',
      'CollateralName': 'Savings account',
      'LoanAmount': 50000,
      'SuretyAmount': 15000,
      'LoanBalance': 32000,
      'SuretyRelaseAmount': 3000,
      'StartDate': '2024-01-10T00:00:00.000',
      'EndDate': '2026-01-10T00:00:00.000',
      'LastPaidDate': '2025-06-18T00:00:00.000',
      'DefaulterStatus': true,
      'DefaultDetails': 'Payment overdue',
      'SurityStatus': 'Active',
    });

    expect(model.id, 8);
    expect(model.loanNumber, 'LN-108');
    expect(model.loanOpenDate, DateTime(2024, 1, 10));
    expect(model.suretyAccountNumber, 'SA-80');
    expect(model.accountHolderName, 'Surety Member');
    expect(model.loanAmount, 50000.0);
    expect(model.suretyAmount, 15000.0);
    expect(model.loanBalance, 32000.0);
    expect(model.suretyReleaseAmount, 3000.0);
    expect(model.lastPaidDate, DateTime(2025, 6, 18));
    expect(model.defaulter, isTrue);
    expect(model.defaulterReason, 'Payment overdue');
    expect(model.status, 'Active');
    expect(model.toJson()['loanNumber'], 'LN-108');
  });
}
