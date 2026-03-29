import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_summery_entity.dart';

class LeaveSummeryModel extends LeaveSummeryEntity {
  LeaveSummeryModel({
    required super.id,
    required super.leaveTypeCode,
    required super.leaveType,
    required super.employeeId,
    required super.totalLeaveDays,
    required super.balance,
    required super.totalLeaveApplied,
    required super.lastApplicationDate,
    required super.maxBalance,
    required super.minimumNoticeDay,
    required super.maxLeaveAtATime,
    required super.documentsRequiredDays,
    required super.maximumHourLeave,
    required super.applyBeforeDays,
    required super.isFallbackRequired,
    required super.maximumFallbackDays,
    required super.isEditable,
    required super.isRejoinDateRequired,
    required super.enableFutureDateApplication,
    required super.enablePastDateApplication,
    required super.withTime,
    required super.enablePresentDateApplication,
    required super.requireToDate,
  });

  factory LeaveSummeryModel.fromJson(Map<String, dynamic> json) {
    return LeaveSummeryModel(
      id: json['LeaveTypeCode'] ?? '',
      leaveTypeCode: json['LeaveTypeCode'] ?? '',
      leaveType: json['LeaveType'] ?? '',
      employeeId: json['EmployeeId'] ?? 0,
      totalLeaveDays: json['TotalLeaveDays'] ?? 0.0,
      balance: json['Balance'] ?? 0.0,
      totalLeaveApplied: json['TotalLeaveApplied'] ?? 0.0,
      lastApplicationDate: json['LastApplicationDate'] ?? '',
      maxBalance: json['MaxBalance'] ?? 0,
      minimumNoticeDay: json['MinimumNoticeDay'] ?? 0,
      maxLeaveAtATime: json['MaxLeaveAtATime'] ?? 0,
      documentsRequiredDays: json['DocumentsRequiredDays'] ?? 0,
      maximumHourLeave: json['MaximumHourLeave'] ?? 0.0,
      applyBeforeDays: json['ApplyBeforeDays'] ?? 0,
      isFallbackRequired: json['IsFallbackRequired'] ?? false,
      maximumFallbackDays: json['MaximumFallbackDays'] ?? 0,
      isEditable: json['IsEditable'] ?? false,
      isRejoinDateRequired: json['IsRejoinDateRequired'] ?? false,
      enableFutureDateApplication: json['EnableFutureDateApplication'] ?? false,
      enablePastDateApplication: json['EnablePastDateApplication'] ?? false,
      withTime: json['WithTime'] ?? false,
      enablePresentDateApplication:
          json['EnablePresentDateApplication'] ?? false,
      requireToDate: json['RequireToDate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LeaveTypeCode': leaveTypeCode,
      'LeaveType': leaveType,
      'EmployeeId': employeeId,
      'TotalLeaveDays': totalLeaveDays,
      'Balance': balance,
      'TotalLeaveApplied': totalLeaveApplied,
      'LastApplicationDate': lastApplicationDate,
      'MaxBalance': maxBalance,
      'MinimumNoticeDay': minimumNoticeDay,
      'MaxLeaveAtATime': maxLeaveAtATime,
      'DocumentsRequiredDays': documentsRequiredDays,
      'MaximumHourLeave': maximumHourLeave,
      'ApplyBeforeDays': applyBeforeDays,
      'IsFallbackRequired': isFallbackRequired,
      'MaximumFallbackDays': maximumFallbackDays,
      'IsEditable': isEditable,
      'IsRejoinDateRequired': isRejoinDateRequired,
      'EnableFutureDateApplication': enableFutureDateApplication,
      'EnablePastDateApplication': enablePastDateApplication,
      'WithTime': withTime,
      'EnablePresentDateApplication': enablePresentDateApplication,
      'RequireToDate': requireToDate,
    };
  }
}
