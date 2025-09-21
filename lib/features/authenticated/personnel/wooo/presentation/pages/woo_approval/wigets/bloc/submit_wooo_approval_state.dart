part of 'submit_wooo_approval_bloc.dart';

sealed class SubmitWoooApprovalState extends Equatable {
  const SubmitWoooApprovalState();

  @override
  List<Object> get props => [];
}

final class SubmitWoooApprovalInitial extends SubmitWoooApprovalState {
  const SubmitWoooApprovalInitial();
}

final class SubmitWoooApprovalLoading extends SubmitWoooApprovalState {
  const SubmitWoooApprovalLoading();
}

final class SubmitWoooApprovalSuccess extends SubmitWoooApprovalState {
  final String message;

  const SubmitWoooApprovalSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class SubmitWoooApprovalError extends SubmitWoooApprovalState {
  final String message;

  const SubmitWoooApprovalError(this.message);

  @override
  List<Object> get props => [message];
}
