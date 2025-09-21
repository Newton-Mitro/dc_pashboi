import 'package:pashboi/core/entities/entity.dart';

class TodayPunchEntity extends Entity<int> {
  final String employeeName;
  final String designationName;
  final String attendanceDate;
  final String punchArea;
  final String checkInTime;
  final String departmentName;
  final String remarks;
  final String employeeCode;
  final String fromDate;
  final String toDate;
  final String searchText;
  TodayPunchEntity({
    super.id,
    required this.employeeName,
    required this.designationName,
    required this.attendanceDate,
    required this.punchArea,
    required this.checkInTime,
    required this.departmentName,
    required this.remarks,
    required this.employeeCode,
    required this.fromDate,
    required this.toDate,
    required this.searchText,
  });

  @override
  List<Object?> get props => [
    id,
    employeeName,
    designationName,
    attendanceDate,
    punchArea,
    checkInTime,
    departmentName,
    remarks,
    employeeCode,
    fromDate,
    toDate,
    searchText,
  ];
}
