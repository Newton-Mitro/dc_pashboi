import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';

class LeaveApplicationRequestModel extends LeaveApplicationEntities {
  LeaveApplicationRequestModel({
    required String id,
    required super.leaveTypeCode,
    required super.leaveType,
    required super.leaveApplicationId,
    required super.employeeId,
    required super.employeeName,
    required super.departmentName,
    required super.designationName,
    required super.applicationDate,
    required super.rejoiningDate,
    required super.totalLeaveDays,
    required super.remarks,
    required super.supervisorName,
    required super.fullName,
    required super.fallbackEmployeeCode,
    required super.fallbackPersonId,
    required super.fallbackPersonName,
    required super.currentStage,
    required super.stageCode,
    required super.fromDate,
    required super.toDate,
    required super.employeeCode,
  }) : super(id: leaveTypeCode);

  factory LeaveApplicationRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveApplicationRequestModel(
      id: json['LeaveTypeCode'] ?? '',
      leaveTypeCode: json['LeaveTypeCode'] ?? '',
      leaveType: json['LeaveType'] ?? '',
      leaveApplicationId: json['LeaveApplicationId'] ?? 0,
      employeeId: json['EmployeeId'] ?? 0,
      employeeName: json['EmployeeName'] ?? '',
      departmentName: json['DepartmentName'] ?? '',
      designationName: json['DesignationName'] ?? '',
      applicationDate: json['ApplicationDate'] ?? '',
      rejoiningDate: json['RejoiningDate'] ?? '',
      totalLeaveDays: (json['TotalLeaveDays'] ?? 0).toDouble(),
      remarks: json['Remarks'] ?? '',
      supervisorName: json['SupervisorName'] ?? '',
      fullName: json['FullName'] ?? '',
      fallbackEmployeeCode: json['FallbackEmployeeCode'] ?? '',
      fallbackPersonId: json['FallbackPersonId'] ?? 0,
      fallbackPersonName: json['FallbackPersonName'] ?? '',
      currentStage: json['CurrentStage'] ?? '',
      stageCode: json['StageCode'] ?? '',
      fromDate: DateTime.parse(json['FromDate']),
      toDate: DateTime.parse(json['ToDate']),
      employeeCode: json['EmployeeCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': leaveTypeCode,
      'LeaveTypeCode': leaveTypeCode,
      'LeaveType': leaveType,
      'LeaveApplicationId': leaveApplicationId,
      'EmployeeId': employeeId,
      'EmployeeName': employeeName,
      'DepartmentName': departmentName,
      'DesignationName': designationName,
      'ApplicationDate': applicationDate,
      'RejoiningDate': rejoiningDate,
      'TotalLeaveDays': totalLeaveDays,
      'Remarks': remarks,
      'SupervisorName': supervisorName,
      'FullName': fullName,
      'FallbackEmployeeCode': fallbackEmployeeCode,
      'FallbackPersonId': fallbackPersonId,
      'FallbackPersonName': fallbackPersonName,
      'CurrentStage': currentStage,
      'StageCode': stageCode,
      'FromDate': fromDate.toIso8601String(),
      'ToDate': toDate.toIso8601String(),
      'EmployeeCode': employeeCode,
    };
  }
}
