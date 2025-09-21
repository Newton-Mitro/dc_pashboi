part of 'leave_type_balance_bloc.dart';

sealed class LeaveTypeBalanceEvent extends Equatable {
  const LeaveTypeBalanceEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaveTypeBalanceEvent extends LeaveTypeBalanceEvent {
  final String leaveTypeCode;
  const FetchLeaveTypeBalanceEvent(this.leaveTypeCode);
}
