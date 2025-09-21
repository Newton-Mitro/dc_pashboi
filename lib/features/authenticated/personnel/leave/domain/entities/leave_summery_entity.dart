import 'package:pashboi/core/entities/entity.dart';

class LeaveSummeryEntity extends Entity<String> {
  final String leaveTypeCode;
  final String leaveType;
  final int employeeId;
  final double totalLeaveDays;
  final double balance;
  final double totalLeaveApplied;
  final String lastApplicationDate;
  final int maxBalance;
  final int minimumNoticeDay;
  final int maxLeaveAtATime;
  final int documentsRequiredDays;
  final double maximumHourLeave;
  final int applyBeforeDays;
  final bool isFallbackRequired;
  final int maximumFallbackDays;
  final bool isEditable;
  final bool isRejoinDateRequired;
  final bool enableFutureDateApplication;
  final bool enablePastDateApplication;
  final bool withTime;
  final bool enablePresentDateApplication;
  final bool requireToDate;
  LeaveSummeryEntity({
    required String id,
    required this.leaveTypeCode,
    required this.leaveType,
    required this.employeeId,
    required this.totalLeaveDays,
    required this.balance,
    required this.totalLeaveApplied,
    required this.lastApplicationDate,
    required this.maxBalance,
    required this.minimumNoticeDay,
    required this.maxLeaveAtATime,
    required this.documentsRequiredDays,
    required this.maximumHourLeave,
    required this.applyBeforeDays,
    required this.isFallbackRequired,
    required this.maximumFallbackDays,
    required this.isEditable,
    required this.isRejoinDateRequired,
    required this.enableFutureDateApplication,
    required this.enablePastDateApplication,
    required this.withTime,
    required this.enablePresentDateApplication,
    required this.requireToDate,
  }) : super(id: id);

  @override
  List<Object?> get props => [
    id,
    leaveTypeCode,
    leaveType,
    employeeId,
    totalLeaveDays,
    balance,
    totalLeaveApplied,
    lastApplicationDate,
    maxBalance,
    minimumNoticeDay,
    maxLeaveAtATime,
    documentsRequiredDays,
    maximumHourLeave,
    applyBeforeDays,
    isFallbackRequired,
    maximumFallbackDays,
    isEditable,
    isRejoinDateRequired,
    enableFutureDateApplication,
    enablePastDateApplication,
    withTime,
    enablePresentDateApplication,
    requireToDate,
  ];
}
