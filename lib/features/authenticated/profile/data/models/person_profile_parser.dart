import 'dart:convert';

import 'package:pashboi/features/authenticated/profile/data/models/person_model.dart';

PersonModel parsePersonProfileJson(String jsonString) {
  final decoded = jsonDecode(jsonString);
  if (decoded is! List || decoded.isEmpty || decoded.first is! Map) {
    throw const FormatException('Profile response did not contain a person');
  }

  return PersonModel.fromJson(Map<String, dynamic>.from(decoded.first as Map));
}
