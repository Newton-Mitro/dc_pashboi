import 'package:pashboi/core/entities/entity.dart';

class LeaveApplicationEntities extends Entity<String> {
  final String leaveTypeCode;
  final String leaveType;
  final int employeeId;
  final double totalLeaveDays;
  final int leaveApplicationId;
  final String employeeName;
  final String departmentName;
  final String designationName;
  final String applicationDate;
  final String rejoiningDate;
  final String remarks;
  final String supervisorName;
  final String fullName;
  final String fallbackEmployeeCode;
  final int fallbackPersonId;
  final String fallbackPersonName;
  final String currentStage;
  final String stageCode;
  final DateTime fromDate;
  final DateTime toDate;
  final String employeeCode;

  LeaveApplicationEntities({
    required super.id,
    required this.leaveTypeCode,
    required this.leaveType,
    required this.leaveApplicationId,
    required this.employeeId,
    required this.employeeName,
    required this.departmentName,
    required this.designationName,
    required this.applicationDate,
    required this.rejoiningDate,
    required this.totalLeaveDays,
    required this.remarks,
    required this.supervisorName,
    required this.fullName,
    required this.fallbackEmployeeCode,
    required this.fallbackPersonId,
    required this.fallbackPersonName,
    required this.currentStage,
    required this.stageCode,
    required this.fromDate,
    required this.toDate,
    required this.employeeCode,
  });

  @override
  List<Object?> get props => [
    id,
    leaveTypeCode,
    leaveType,
    leaveApplicationId,
    employeeId,
    employeeName,
    departmentName,
    designationName,
    applicationDate,
    rejoiningDate,
    totalLeaveDays,
    remarks,
    supervisorName,
    fullName,
    fallbackEmployeeCode,
    fallbackPersonId,
    fallbackPersonName,
    currentStage,
    stageCode,
    fromDate,
    toDate,
    employeeCode,
  ];
}
