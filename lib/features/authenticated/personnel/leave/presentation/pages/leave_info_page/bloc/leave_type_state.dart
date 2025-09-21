part of 'leave_type_bloc.dart';

sealed class LeaveTypeState extends Equatable {
  const LeaveTypeState();

  @override
  List<Object> get props => [];
}

final class LeaveTypeInitial extends LeaveTypeState {
  const LeaveTypeInitial();
}

final class LeaveTypeLoading extends LeaveTypeState {
  const LeaveTypeLoading();
}

final class LeaveTypeSuccess extends LeaveTypeState {
  final List<LeaveTypeEntity> leaveTypeEntity;

  const LeaveTypeSuccess(this.leaveTypeEntity);

  @override
  List<Object> get props => [leaveTypeEntity];
}

final class LeaveTypeError extends LeaveTypeState {
  final String message;

  const LeaveTypeError(this.message);

  @override
  List<Object> get props => [message];
}
