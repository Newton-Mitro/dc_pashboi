part of 'leave_approval_bloc.dart';

sealed class LeaveApprovalState extends Equatable {
  const LeaveApprovalState();

  @override
  List<Object> get props => [];
}

final class LeaveApprovalInitial extends LeaveApprovalState {}

final class LeaveApprovalLoading extends LeaveApprovalState {
  const LeaveApprovalLoading();
}

final class LeaveApprovalSuccess extends LeaveApprovalState {
  final List<LeaveApplicationEntities> approvals;

  const LeaveApprovalSuccess(this.approvals);

  @override
  List<Object> get props => [approvals];
}

final class LeaveApprovalError extends LeaveApprovalState {
  final String message;

  const LeaveApprovalError(this.message);

  @override
  List<Object> get props => [message];
}
