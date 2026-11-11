import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/deposit/data/models/bkash_payment_model.dart';
import 'package:pashboi/features/authenticated/deposit/data/models/transaction_model.dart';
import 'package:pashboi/features/authenticated/deposit/data/models/voucher_model.dart';

void main() {
  test('TransactionModel maps transaction fields', () {
    final model = TransactionModel.fromJson({
      'id': 4,
      'TransferRequestId': 12,
      'Amount': 850.5,
      'TransferToAcc': 'SA-2',
      'AccHolder': 'Member',
      'Particulars': 'Monthly deposit',
    });

    expect(model.id, 4);
    expect(model.requestId, 12);
    expect(model.amount, 850.5);
    expect(model.accountNumber, 'SA-2');
    expect(model.accountHolder, 'Member');
    expect(model.perticulars, 'Monthly deposit');
  });

  test('DepositRequestModel parses its details and dates', () {
    final model = DepositRequestModel.fromJson({
      'Id': 8,
      'Status': 'Pending',
      'RequestDate': '2025-06-18T10:00:00.000',
      'DepositDate': '2025-06-20T00:00:00.000',
      'AccHolder': 'Member',
      'TransactionMethod': '12',
      'TransactionType': 'DepositRequest',
      'Details': [
        {
          'TransferRequestId': 8,
          'Amount': 1000,
          'TransferToAcc': 'SA-1',
          'AccHolder': 'Member',
          'Particulars': 'Savings deposit',
        },
      ],
    });

    expect(model.id, 8);
    expect(model.status, 'Pending');
    expect(model.requestDate, DateTime(2025, 6, 18, 10));
    expect(model.depositDate, DateTime(2025, 6, 20));
    expect(model.transactions, hasLength(1));
    expect(model.transactions.single.amount, 1000.0);
    expect(model.transactions.single.requestId, 8);
  });

  test('BkashPaymentModel maps and serializes the payment response', () {
    final model = BkashPaymentModel.fromJson({
      'statusCode': '0000',
      'statusMessage': 'Successful',
      'paymentID': 'payment-1',
      'bkashURL': 'https://example.test/pay',
      'callbackURL': 'https://example.test/callback',
      'successCallbackURL': 'https://example.test/success',
      'failureCallbackURL': 'https://example.test/failure',
      'cancelledCallbackURL': 'https://example.test/cancel',
      'amount': '250.00',
      'intent': 'sale',
      'currency': 'BDT',
      'paymentCreateTime': '2025-06-18T10:00:00.000',
      'transactionStatus': 'Initiated',
      'merchantInvoiceNumber': 'INV-1',
    });

    expect(model.paymentId, 'payment-1');
    expect(model.bkashUrl, 'https://example.test/pay');
    expect(model.amount, '250.00');
    expect(model.transactionStatus, 'Initiated');
    expect(model.toJson()['merchantInvoiceNumber'], 'INV-1');
  });
}
