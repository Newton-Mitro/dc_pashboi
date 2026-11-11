import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/transfer/data/models/dc_bank_model.dart';

void main() {
  test('maps bank details from API and back', () {
    final model = DcBankModel.fromJson({
      'BankId': 'bank-1',
      'BankName': 'Example Bank',
      'BankAccNumber': '123456789',
      'BankRoutingNo': '987654321',
      'BankBranch': 'Central',
    });

    expect(model.id, 'bank-1');
    expect(model.bankName, 'Example Bank');
    expect(model.bankAccNumber, '123456789');
    expect(model.bankRoutingNo, '987654321');
    expect(model.bankBranch, 'Central');
    expect(model.toJson(), {
      'BankId': 'bank-1',
      'BankName': 'Example Bank',
      'BankAccNumber': '123456789',
      'BankRoutingNo': '987654321',
      'BankBranch': 'Central',
    });
  });
}
