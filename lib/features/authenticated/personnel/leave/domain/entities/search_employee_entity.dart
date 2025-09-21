import 'package:pashboi/core/entities/entity.dart';

class SearchEmployeeEntity extends Entity<String> {
  final String fullName;
  final DateTime dateOfBirth;
  final int employeeId;
  final int personId;
  final String employeeCode;
  SearchEmployeeEntity({
    required this.fullName,
    required this.dateOfBirth,
    required this.employeeId,
    required this.personId,
    required this.employeeCode,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    dateOfBirth,
    employeeId,
    personId,
    employeeCode,
  ];
}
