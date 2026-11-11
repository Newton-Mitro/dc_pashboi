import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/eligible_conditions_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_account_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_transaction_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/product_loan_collateral_account_model.dart';

void main() {
  group('LoanAccountModel', () {
    test('maps loan fields and API date formats', () {
      final model = LoanAccountModel.fromJson({
        'id': 7,
        'LoanNumber': 'LN-321',
        'LoanType': 'Personal Loan',
        'AccountTypeShortName': 'PL',
        'LoanProductCode': 'PROD-1',
        'ModuleCode': 'LOAN',
        'IssuedAmount': 100000,
        'LoanBalance': 65000.5,
        'LoanRefundAmount': 12000,
        'InterestRate': 8.5,
        'Days': 90,
        'Installment': '12',
        'LoanEndDate': '2027-01-30T00:00:00.000',
        'LastPaidDate': '2025/06/18',
        'IssuedDate': '2024/01/20',
        'LoaneeName': 'A. Member',
        'IsDefaulter': true,
        'DefaultDetails': 'One installment overdue',
        'LoanStatus': 'Open',
      });

      expect(model.number, 'LN-321');
      expect(model.typeName, 'Personal Loan');
      expect(model.issuedAmount, 100000.0);
      expect(model.loanBalance, 65000.5);
      expect(model.interestForDays, 90);
      expect(model.lastPaidDate, DateTime(2025, 6, 18));
      expect(model.issuedDate, DateTime(2024, 1, 20));
      expect(model.defaulter, isTrue);
      expect(model.status, 'Open');
    });

    test('uses supported loan ID alias and defaults optional values', () {
      final model = LoanAccountModel.fromJson({
        'LoanId': 'LN-123',
        'LoanBalance': 10,
      });

      expect(model.number, 'LN-123');
      expect(model.loanBalance, 10.0);
      expect(model.issuedAmount, 0.0);
      expect(model.status, 'Active');
      expect(model.defaulterReason, 'N/A');
    });
  });

  test('LoanTransactionModel parses amounts and serializes', () {
    final model = LoanTransactionModel.fromJson({
      'id': 2,
      'LoanId': 'LN-123',
      'TxnDate': '2025-06-18T13:20:07.000',
      'Particulars': 'Installment payment',
      'Withdrawal': 200,
      'Deposit': 1500,
      'Balance': 8000,
      'LoanIssue': '10000.25',
    });

    expect(model.loanNumber, 'LN-123');
    expect(model.transactionDate, DateTime(2025, 6, 18, 13, 20, 7));
    expect(model.debitAmount, 200.0);
    expect(model.creditAmount, 1500.0);
    expect(model.loanIssuedAmount, 10000.25);
    expect(model.toJson(), {
      'id': 2,
      'loanNumber': 'LN-123',
      'transactionDate': '2025-06-18T13:20:07.000',
      'particulars': 'Installment payment',
      'debitAmount': 200.0,
      'creditAmount': 1500.0,
      'balanceAmount': 8000.0,
      'loanIssuedAmount': 10000.25,
    });
  });

  group('EligibleConditionsModel', () {
    test('converts numeric and boolean API representations', () {
      final model = EligibleConditionsModel.fromJson({
        'id': 8,
        'ItemName': 'Previous loan repaid',
        'IsEligibile': 1,
        'ItemValue': '1000.5',
        'LoaneeValue': 5,
        'LoanAmount': 8000,
        'EligibleLoanProductCode': 'PL-1',
        'SavingsAccNo': 'SA-10',
        'LoanMemberType': 'Member',
        'LoanAmountRules': 'Rule A',
        'IsTopUpEligible': 'true',
      });

      expect(model.id, 8);
      expect(model.isEligibile, isTrue);
      expect(model.itemValue, 1000.5);
      expect(model.loanAmount, 8000.0);
      expect(model.isTopUpEligible, isTrue);
      expect(
        EligibleConditionsModel.fromJson(model.toJson()).isEligibile,
        isTrue,
      );
    });

    test('defaults invalid numeric and boolean values', () {
      final model = EligibleConditionsModel.fromJson({
        'ItemValue': 'not-a-number',
        'IsEligibile': 'yes',
      });

      expect(model.itemValue, 0.0);
      expect(model.isEligibile, isFalse);
      expect(model.isTopUpEligible, isFalse);
    });
  });

  test('ProductLoanCollateralAccountModel accepts string IDs and lists', () {
    final model = ProductLoanCollateralAccountModel.fromJson({
      'AccountId': '17',
      'AccountType': 'Savings',
      'AccountNumber': 'SA-17',
      'TotalBalance': 5000,
      'LoanableBalance': 4000,
      'PartialApplyLoan': 2500,
      'IsEligible': 'true',
      'WithdrawableBalance': 3500,
    });

    expect(model.id, 17);
    expect(model.accountNumber, 'SA-17');
    expect(model.partialApplyLoan, '2500');
    expect(model.isEligible, isTrue);
    expect(
      ProductLoanCollateralAccountModel.listToJson([model]).single,
      model.toJson(),
    );
  });
}
