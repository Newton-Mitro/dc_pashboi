part of 'submit_leave_approval_bloc.dart';

sealed class SubmitLeaveApprovalState extends Equatable {
  const SubmitLeaveApprovalState();

  @override
  List<Object> get props => [];
}

final class SubmitLeaveApprovalInitial extends SubmitLeaveApprovalState {
  const SubmitLeaveApprovalInitial();
}

final class SubmitLeaveApprovalLoading extends SubmitLeaveApprovalState {
  const SubmitLeaveApprovalLoading();
}

final class SubmitLeaveApprovalSuccess extends SubmitLeaveApprovalState {
  final String message;

  const SubmitLeaveApprovalSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class SubmitLeaveApprovalError extends SubmitLeaveApprovalState {
  final String message;

  const SubmitLeaveApprovalError(this.message);

  @override
  List<Object> get props => [message];
}
