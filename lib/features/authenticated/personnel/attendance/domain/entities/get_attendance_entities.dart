import 'package:pashboi/core/entities/entity.dart';

class GetAttendanceEntities extends Entity<String> {
  final String remarks;
  final String departmentName;
  final String designationName;
  final String branchName;
  final String employeeName;
  final String attendanceDate;
  final String punchArea;
  final String scheduleType;
  final String status;
  final String workHour;
  final String punchIn;
  final String punchOut;
  final String employeeCode;

  GetAttendanceEntities({
    super.id,
    required this.remarks,
    required this.departmentName,
    required this.designationName,
    required this.branchName,
    required this.employeeName,
    required this.attendanceDate,
    required this.punchArea,
    required this.scheduleType,
    required this.status,
    required this.punchIn,
    required this.punchOut,
    required this.workHour,
    required this.employeeCode,
  });

  @override
  List<Object?> get props => [
    id,
    remarks,
    departmentName,
    designationName,
    branchName,
    employeeName,
    attendanceDate,
    punchArea,
    scheduleType,
    status,
    workHour,
    employeeCode,
  ];
}
