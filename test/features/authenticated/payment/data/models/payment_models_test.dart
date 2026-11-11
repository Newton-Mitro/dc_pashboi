import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/payment/data/models/notify_person_model.dart';
import 'package:pashboi/features/authenticated/payment/data/models/service_model.dart';

void main() {
  test('NotifyPersonModel maps person fields in both directions', () {
    final model = NotifyPersonModel.fromJson({
      'PersonId': 12,
      'FullName': 'Member Contact',
      'MobileNumber': '01700000000',
    });

    expect(model.id, 12);
    expect(model.fullName, 'Member Contact');
    expect(model.mobileNumber, '01700000000');
    expect(model.toJson(), {
      'PersonId': 12,
      'FullName': 'Member Contact',
      'MobileNumber': '01700000000',
    });
  });

  test('ServiceModel parses nested notification contacts and serializes', () {
    final model = ServiceModel.fromJson({
      'ServiceId': 4,
      'ServiceCode': 'UTIL-1',
      'ServiceName': 'Utility payment',
      'ServiceAccount': 'SA-100',
      'ServiceIcon': 'utility',
      'ServiceType': 'Utility',
      'NotifyPerson': [
        {
          'PersonId': 12,
          'FullName': 'Member Contact',
          'MobileNumber': '01700000000',
        },
      ],
      'Remarks': 'Electricity',
    });

    expect(model.id, 4);
    expect(model.serviceCode, 'UTIL-1');
    expect(model.serviceName, 'Utility payment');
    expect(model.notifyPersons.single.fullName, 'Member Contact');
    expect(model.toJson()['NotifyPerson'], [
      {
        'PersonId': 12,
        'FullName': 'Member Contact',
        'MobileNumber': '01700000000',
      },
    ]);
  });

  test('ServiceModel defaults a missing contacts list', () {
    final model = ServiceModel.fromJson({});

    expect(model.serviceName, isEmpty);
    expect(model.notifyPersons, isEmpty);
    expect(model.remarks, isEmpty);
  });
}
