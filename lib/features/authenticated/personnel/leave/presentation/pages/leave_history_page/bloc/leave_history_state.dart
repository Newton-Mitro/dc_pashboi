part of 'leave_history_bloc.dart';

sealed class LeaveHistoryState extends Equatable {
  const LeaveHistoryState();

  @override
  List<Object> get props => [];
}

final class LeaveHistoryInitial extends LeaveHistoryState {
  const LeaveHistoryInitial();
}

final class LeaveHistoryLoading extends LeaveHistoryState {
  const LeaveHistoryLoading();
}

final class LeaveHistorySuccess extends LeaveHistoryState {
  final List<LeaveApplicationEntities> requests;

  const LeaveHistorySuccess(this.requests);

  @override
  List<Object> get props => [requests];
}

final class LeaveHistoryError extends LeaveHistoryState {
  final String message;

  const LeaveHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
