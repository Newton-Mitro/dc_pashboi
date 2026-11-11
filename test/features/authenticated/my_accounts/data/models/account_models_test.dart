import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/models/account_transaction_model.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/models/deposit_account_model.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/models/nominee_model.dart';

void main() {
  group('DepositAccountModel', () {
    test('maps API account fields and dates', () {
      final model = DepositAccountModel.fromJson({
        'AccountId': 12,
        'AccountNo': 'DC-123',
        'AccHolderName': 'A. Member',
        'AccountHolderId': 45,
        'AccountTypeName': 'Monthly Deposit',
        'AccountTypeShortName': 'MDS',
        'AccountTypeCode': 7,
        'Balance': 12500,
        'WithdrawableBalance': 5000.5,
        'LastPaidDate': '2025-06-18T00:00:00.000',
        'AccountNominee': 'Nominee',
        'MaturityDate': '2030-06-18T00:00:00.000',
        'MobileNumber': '+88017000000000',
        'LedgerId': 88,
        'InterestRate': 6.25,
        'AccountFor': 'Personal',
        'Status': 'Active',
        'IsDefaulter': true,
      });

      expect(model.id, 12);
      expect(model.number, 'DC-123');
      expect(model.name, 'A. Member');
      expect(model.accountHolderId, 45);
      expect(model.typeName, 'Monthly Deposit');
      expect(model.typeCode, '7');
      expect(model.balance, 12500.0);
      expect(model.withdrawableBalance, 5000.5);
      expect(model.lastPaidDate, DateTime(2025, 6, 18));
      expect(model.maturityDate, DateTime(2030, 6, 18));
      expect(model.defaultAccount, isTrue);
    });

    test('accepts alternate account fields and defaults absent values', () {
      final model = DepositAccountModel.fromJson({
        'AccountNumber': 'DC-456',
        'AccountHolderName': 'B. Member',
      });

      expect(model.number, 'DC-456');
      expect(model.name, 'B. Member');
      expect(model.accountHolderName, 'B. Member');
      expect(model.accountHolderId, 0);
      expect(model.balance, 0);
      expect(model.accountFor, 'Individual');
      expect(model.status, 'Active');
      expect(model.defaultAccount, isFalse);
    });
  });

  test('NomineeModel parses and serializes nominee details', () {
    final model = NomineeModel.fromJson({
      'id': 5,
      'name': 'Nominee Name',
      'relation': 'Spouse',
      'phone': '+88017000000000',
      'nationalId': '1234567890',
      'percentage': 60,
      'dateOfBirth': '1995-02-03T00:00:00.000',
      'address': 'Dhaka',
    });

    expect(model.id, 5);
    expect(model.percentage, 60.0);
    expect(model.dateOfBirth, DateTime(1995, 2, 3));
    expect(model.toJson(), {
      'id': 5,
      'name': 'Nominee Name',
      'relation': 'Spouse',
      'phone': '+88017000000000',
      'nationalId': '1234567890',
      'percentage': 60.0,
      'dateOfBirth': '1995-02-03T00:00:00.000',
      'address': 'Dhaka',
    });
  });

  test('AccountTransactionModel parses monetary fields and date', () {
    final model = AccountTransactionModel.fromJson({
      'id': 3,
      'TxnDate': '2025-06-18T13:20:07.000',
      'Particulars': 'Monthly deposit',
      'WithdrawAmount': 25,
      'DepositAmount': 500,
      'Balance': 2500.75,
    });

    expect(model.id, 3);
    expect(model.date, DateTime(2025, 6, 18, 13, 20, 7));
    expect(model.debit, 25.0);
    expect(model.credit, 500.0);
    expect(model.balance, 2500.75);
    expect(model.toJson()['date'], '2025-06-18T13:20:07.000');
  });
}
