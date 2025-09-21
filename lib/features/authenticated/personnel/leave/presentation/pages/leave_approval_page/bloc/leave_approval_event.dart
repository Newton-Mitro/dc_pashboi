part of 'leave_approval_bloc.dart';

sealed class LeaveApprovalEvent extends Equatable {
  const LeaveApprovalEvent();

  @override
  List<Object> get props => [];
}

final class FetchLeaveApprovals extends LeaveApprovalEvent {
  final String fromDate;
  final String toDate;

  const FetchLeaveApprovals({required this.fromDate, required this.toDate});

  @override
  List<Object> get props => [fromDate, toDate];
}
