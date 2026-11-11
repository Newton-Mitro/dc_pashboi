import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/beneficiaries/data/models/beneficiary_model.dart';

void main() {
  test('maps beneficiary fields to and from API JSON', () {
    final model = BeneficiaryModel.fromJson({
      'Id': 7,
      'PersonName': 'Payee Name',
      'AccountNo': 'SA-701',
    });

    expect(model.id, 7);
    expect(model.name, 'Payee Name');
    expect(model.accountNumber, 'SA-701');
    expect(model.toJson(), {
      'Id': 7,
      'PersonName': 'Payee Name',
      'AccountNo': 'SA-701',
    });
  });
}
