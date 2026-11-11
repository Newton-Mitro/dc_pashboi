import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/data/models/collection_ledger_model.dart';

void main() {
  test('parses API numeric representations and defaults optional values', () {
    final model = CollectionLedgerModel.fromJson({
      'Id': '12',
      'AccountNo': 'SA-12',
      'AccountName': 'Member',
      'AccountType': 'Savings',
      'AccountTypeCode': '01',
      'ModuleCode': 'SAV',
      'Amount': '500.75',
      'DepositAmount': 1000,
      'AccountId': 7.9,
      'LedgerId': '25',
      'IsMultiplier': true,
      'IsSubLedger': false,
      'IsNotEditable': true,
      'PlType': '2',
      'LoanBalance': 25000,
      'InterestRate': '8.5',
      'LastPaidDate': '2025-06-18T00:00:00.000',
      'LoanCollectionType': 'LoanLpsAmount',
      'AccountFor': 'Personal',
    });

    expect(model.id, 12);
    expect(model.accountNumber, 'SA-12');
    expect(model.amount, 500);
    expect(model.depositAmount, 1000);
    expect(model.accountId, 7);
    expect(model.ledgerId, 25);
    expect(model.multiplier, isTrue);
    expect(model.plType, 2);
    expect(model.loanBalance, 25000);
    expect(model.intrestRate, 8.5);
    expect(model.lastPaidDate, DateTime(2025, 6, 18));
    expect(model.collectionType, 'LoanLpsAmount');
    expect(model.isSelected, isFalse);
  });

  test('parseInt handles null, decimal, numeric string, and invalid input', () {
    expect(CollectionLedgerModel.parseInt(null), 0);
    expect(CollectionLedgerModel.parseInt(8.7), 8);
    expect(CollectionLedgerModel.parseInt('14.9'), 14);
    expect(CollectionLedgerModel.parseInt('invalid'), 0);
  });
}
