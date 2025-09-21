part of 'update_leave_application_bloc.dart';

sealed class UpdateLeaveApplicationEvent extends Equatable {
  const UpdateLeaveApplicationEvent();

  @override
  List<Object> get props => [];
}

class UpdateLeaveApplication extends UpdateLeaveApplicationEvent {
  final String remarks;
  final String fallbackEmployeeCode;
  final String rejoiningDate;
  final String toDate;
  final String fromDate;
  final String formTime;
  final String toTime;
  final String leaveTypeCode;
  final String leaveStageRemarks;
  final String leaveApplicationId;

  const UpdateLeaveApplication({
    required this.remarks,
    required this.leaveApplicationId,
    required this.fallbackEmployeeCode,
    required this.rejoiningDate,
    required this.toDate,
    required this.formTime,
    required this.toTime,
    required this.fromDate,
    required this.leaveTypeCode,
    required this.leaveStageRemarks,
  });

  @override
  List<Object> get props => [
    remarks,
    fallbackEmployeeCode,
    rejoiningDate,
    toDate,
    fromDate,
    formTime,
    toTime,
    leaveTypeCode,
    leaveStageRemarks,
  ];
}
