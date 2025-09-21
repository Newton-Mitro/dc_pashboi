part of 'leave_history_bloc.dart';

abstract class LeaveHistoryEvent extends Equatable {
  const LeaveHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaveHistory extends LeaveHistoryEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const FetchLeaveHistory({required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [fromDate, toDate];
}
