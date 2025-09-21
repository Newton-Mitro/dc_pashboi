part of 'submit_leave_approval_bloc.dart';

sealed class SubmitLeaveApprovalEvent extends Equatable {
  const SubmitLeaveApprovalEvent();

  @override
  List<Object> get props => [];
}

final class SubmitLeaveApprovals extends SubmitLeaveApprovalEvent {
  final String leaveStageRemarks;
  final int leaveApplicationId;

  const SubmitLeaveApprovals({
    required this.leaveStageRemarks,
    required this.leaveApplicationId,
  });

  @override
  List<Object> get props => [leaveStageRemarks, leaveApplicationId];
}
