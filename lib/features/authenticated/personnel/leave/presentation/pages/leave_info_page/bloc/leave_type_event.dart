part of 'leave_type_bloc.dart';

sealed class LeaveTypeEvent extends Equatable {
  const LeaveTypeEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaveTypeEvent extends LeaveTypeEvent {
  const FetchLeaveTypeEvent();
}
