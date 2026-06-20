import 'package:pashboi/features/authenticated/my_accounts/domain/entities/nominee_entity.dart';

class NomineeModel extends NomineeEntity {
  NomineeModel({
    super.id,
    required super.name,
    required super.relation,
    required super.phone,
    required super.nationalId,
    required super.percentage,
    super.dateOfBirth,
    super.address,
  });

  factory NomineeModel.fromJson(Map<String, dynamic> json) {
    return NomineeModel(
      id: json['id'] ?? 0,

      name: json['name'] ?? '',
      relation: json['relation'] ?? '',
      phone: json['phone'] ?? '',
      nationalId: json['nationalId'] ?? '',
      percentage: (json['percentage'] ?? 0).toDouble(),
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.tryParse(json['dateOfBirth'])
              : null,
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'phone': phone,
      'nationalId': nationalId,
      'percentage': percentage,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
    };
  }
}
