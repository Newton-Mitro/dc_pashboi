import 'package:pashboi/core/entities/entity.dart';

class WoooDataEntities extends Entity<int> {
  final int employeeWoooId;
  final int totalRecords;
  final String woooTypeCode;
  final String rejoiningDate;
  final String reason;
  final bool isHourly;
  final bool byMMS;
  final int appliedBy;
  final int rejectedBy;
  final int totalDays;
  final String totalHour;
  final String applicationDate;
  final int woooTypeId;
  final String woooType;
  final bool isEditable;
  final bool isSupervisorTreeWise;
  final bool registeredStatus;
  final int employeeId;
  final String employeeName;
  final String status;
  final String fromDate;
  final String toDate;

  WoooDataEntities({
    super.id,
    required this.employeeWoooId,
    required this.totalRecords,
    required this.woooTypeCode,
    required this.rejoiningDate,
    required this.reason,
    required this.isHourly,
    required this.byMMS,
    required this.appliedBy,
    required this.rejectedBy,
    required this.totalDays,
    required this.totalHour,
    required this.applicationDate,
    required this.woooTypeId,
    required this.woooType,
    required this.isEditable,
    required this.isSupervisorTreeWise,
    required this.registeredStatus,
    required this.employeeId,
    required this.employeeName,
    required this.status,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [
    id,
    employeeWoooId,
    totalRecords,
    woooTypeCode,
    rejoiningDate,
    reason,
    isHourly,
    byMMS,
    appliedBy,
    rejectedBy,
    totalDays,
    totalHour,
    applicationDate,
    woooTypeId,
    woooType,
    isEditable,
    isSupervisorTreeWise,
    registeredStatus,
    employeeId,
    employeeName,
    status,
    fromDate,
    toDate,
  ];
}
