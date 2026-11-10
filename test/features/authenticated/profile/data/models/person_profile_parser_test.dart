import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/profile/data/models/person_profile_parser.dart';
import 'package:pashboi/features/authenticated/profile/data/models/person_model.dart';

void main() {
  test('parses the profile model in a background isolate', () async {
    final response = jsonEncode([
      {
        'PersonId': 7,
        'FullName': 'Test User',
        'DateOfBirth': '1990-01-01T00:00:00',
        'MobileNumber': '123',
        'Email': 'test@example.com',
        'NID': '',
        'Gender': '',
        'BloodGroup': '',
        'IsBloodDonor': false,
        'UserPhoto': base64Encode(List<int>.filled(4096, 65)),
        'PresentAddressLine1': '',
        'PresentAddressLine2': '',
        'PresentAddressLine3': '',
        'PresentAddressLine4': '',
        'PermanentAddressLine1': '',
        'PermanentAddressLine2': '',
        'PermanentAddressLine3': '',
        'PermanentAddressLine4': '',
        'FathersName': '',
        'MothersName': '',
        'SpouseName': '',
      },
    ]);

    final person = await compute<String, PersonModel>(
      parsePersonProfileJson,
      response,
    );

    expect(person.name, 'Test User');
    expect(person.photo.length, greaterThan(4000));
  });

  test('rejects a response without profile data', () {
    expect(() => parsePersonProfileJson('[]'), throwsFormatException);
  });
}
