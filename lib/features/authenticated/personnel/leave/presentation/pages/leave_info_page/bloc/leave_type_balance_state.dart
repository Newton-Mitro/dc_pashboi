part of 'leave_type_balance_bloc.dart';

sealed class LeaveTypeBalanceState extends Equatable {
  const LeaveTypeBalanceState();

  @override
  List<Object> get props => [];
}

final class LeaveTypeBalanceInitial extends LeaveTypeBalanceState {}

final class LeaveTypeBalanceLoading extends LeaveTypeBalanceState {
  const LeaveTypeBalanceLoading();
}

final class LeaveTypeBalanceSuccess extends LeaveTypeBalanceState {
  final LeaveTypeBalanceDto leaveTypeBalance;

  const LeaveTypeBalanceSuccess(this.leaveTypeBalance);

  @override
  List<Object> get props => [leaveTypeBalance];
}

final class LeaveTypeBalanceError extends LeaveTypeBalanceState {
  final String message;

  const LeaveTypeBalanceError(this.message);

  @override
  List<Object> get props => [message];
}
