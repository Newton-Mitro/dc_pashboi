import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/cards/data/models/card_model.dart';

void main() {
  test('maps card fields and nested linked accounts', () {
    final model = DebitCardModel.fromJson({
      'CardId': 9,
      'CardsAccounts': [
        {
          'AccountId': 12,
          'AccountNo': 'SA-12',
          'AccountTypeName': 'Savings',
          'Balance': 3200,
          'WithdrawableBalance': 1200,
        },
      ],
      'IsActive': true,
      'Name': 'A. Member',
      'CardNo': '1234567890123456',
      'CardType': 'Debit',
      'ExpiryDate': '30/06/2028',
      'IsVirtual': false,
      'IsBlock': false,
      'CardStageCode': 'ACTIVE',
      'CardStageName': 'Active',
    });

    expect(model.id, 9);
    expect(model.cardsAccounts, hasLength(1));
    expect(model.cardsAccounts.single.number, 'SA-12');
    expect(model.cardsAccounts.single.balance, 3200.0);
    expect(model.isActive, isTrue);
    expect(model.nameOnCard, 'A. Member');
    expect(model.cardNumber, '1234567890123456');
    expect(model.type, 'Debit');
    expect(model.expiryDate, '30/06/2028');
    expect(model.isVirtual, isFalse);
    expect(model.isBlock, isFalse);
    expect(model.stageCode, 'ACTIVE');
    expect(model.stageName, 'Active');
    expect(model.toJson()['CardsAccounts'], hasLength(1));
  });

  test('defaults absent optional fields', () {
    final model = DebitCardModel.fromJson({});

    expect(model.id, 0);
    expect(model.cardsAccounts, isEmpty);
    expect(model.isActive, isFalse);
    expect(model.nameOnCard, isEmpty);
    expect(model.cardNumber, isEmpty);
    expect(model.isVirtual, isFalse);
    expect(model.isBlock, isFalse);
  });
}
