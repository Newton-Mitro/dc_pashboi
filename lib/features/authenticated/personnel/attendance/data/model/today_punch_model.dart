import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/today_punch_entity.dart';

class TodayPunchModel extends TodayPunchEntity {
  TodayPunchModel({
    required super.id,
    required super.employeeName,
    required super.designationName,
    required super.attendanceDate,
    required super.punchArea,
    required super.checkInTime,
    required super.departmentName,
    required super.employeeCode,
    required super.remarks,
    required super.fromDate,
    required super.toDate,
    required super.searchText,
  });

  factory TodayPunchModel.fromJson(Map<String, dynamic> json) {
    return TodayPunchModel(
      id: json['Id'] ?? "",
      employeeName: json['EmployeeName'] ?? "",
      designationName: json['DesignationName'] ?? "",
      attendanceDate: json['AttendanceDate'] ?? "",
      punchArea: json['PunchArea'] ?? "",
      checkInTime: json['CheckInTime'] ?? "",
      departmentName: json['DepartmentName'] ?? "",
      employeeCode: json['EmployeeCode'] ?? "",
      remarks: json['Remarks'] ?? "",
      fromDate: json['FromDate'] ?? "",
      toDate: json['ToDate'] ?? "",
      searchText: json['SearchText'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'EmployeeName': employeeName,
      'DesignationName': designationName,
      'AttendanceDate': attendanceDate,
      'PunchArea': punchArea,
      'CheckInTime': checkInTime,
      'DepartmentName': departmentName,
      'EmployeeCode': employeeCode,
      'Remarks': remarks,
      'FromDate': fromDate,
      'ToDate': toDate,
      'SearchText': searchText,
    };
  }
}
