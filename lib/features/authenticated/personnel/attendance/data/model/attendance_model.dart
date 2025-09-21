import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';

class AttendanceModel extends GetAttendanceEntities {
  AttendanceModel({
    required super.id,
    required super.remarks,
    required super.departmentName,
    required super.designationName,
    required super.branchName,
    required super.employeeName,
    required super.attendanceDate,
    required super.punchArea,
    required super.scheduleType,
    required super.status,
    required super.punchIn,
    required super.punchOut,
    required super.workHour,
    required super.employeeCode,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['Id'] ?? '',
      remarks: json['Remarks'] ?? '',
      departmentName: json['DepartmentName'] ?? '',
      designationName: json['DesignationName'] ?? '',
      branchName: json['BranchName'] ?? '',
      employeeName: json['EmployeeName'] ?? '',
      attendanceDate: json['AttendanceDate'] ?? '',
      punchArea: json['PunchArea'] ?? '',
      scheduleType: json['ScheduleType'] ?? '',
      status: json['Status'] ?? '',
      punchIn: json['PunchIn'] ?? '',
      punchOut: json['PunchOut'] ?? '',
      workHour: json['WorkHour'] ?? '',
      employeeCode: json['EmployeeCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Remarks': remarks,
      'DepartmentName': departmentName,
      'DesignationName': designationName,
      'BranchName': branchName,
      'EmployeeName': employeeName,
      'AttendanceDate': attendanceDate,
      'PunchArea': punchArea,
      'ScheduleType': scheduleType,
      'Status': status,
      'WorkHour': workHour,
      'EmployeeCode': employeeCode,
    };
  }
}
