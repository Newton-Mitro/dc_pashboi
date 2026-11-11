import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/agm_counter/data/models/agm_counter_model.dart';

void main() {
  test('maps AGM counter fields to and from API JSON', () {
    final model = AGMCounterModel.fromJson({
      'SlNo': 3,
      'CounterNo': 'C-03',
      'LocationName': 'Main Hall',
      'AccountNo': 'SA-10',
      'FullName': 'Member Name',
    });

    expect(model.id, 3);
    expect(model.slNo, 3);
    expect(model.counterNo, 'C-03');
    expect(model.locationName, 'Main Hall');
    expect(model.accountNo, 'SA-10');
    expect(model.fullName, 'Member Name');
    expect(model.toJson(), {
      'SlNo': 3,
      'CounterNo': 'C-03',
      'LocationName': 'Main Hall',
      'AccountNo': 'SA-10',
      'FullName': 'Member Name',
    });
  });
}
