import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/search_employee_entity.dart';

class SearchEmployeeModel extends SearchEmployeeEntity {
  SearchEmployeeModel({
    required super.fullName,
    required super.dateOfBirth,
    required super.employeeId,
    required super.personId,
    required super.employeeCode,
  });

  factory SearchEmployeeModel.fromJson(Map<String, dynamic> json) {
    return SearchEmployeeModel(
      fullName: json['FullName'] ?? 'N/A',
      dateOfBirth:
          DateTime.tryParse(json['DateOfBirth'] ?? '') ?? DateTime(1970),
      employeeId: json['EmployeeId'] ?? 0,
      personId: json['PersonId'] ?? 0,
      employeeCode: json['EmployeeCode']?.toString() ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FullName': fullName,
      'DateOfBirth': dateOfBirth.toIso8601String(),
      'EmployeeId': employeeId,
      'PersonId': personId,
      'EmployeeCode': employeeCode,
    };
  }
}
