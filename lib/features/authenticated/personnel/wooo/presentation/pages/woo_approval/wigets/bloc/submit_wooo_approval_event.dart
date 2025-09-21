part of 'submit_wooo_approval_bloc.dart';

sealed class SubmitWoooApprovalEvent extends Equatable {
  const SubmitWoooApprovalEvent();

  @override
  List<Object> get props => [];
}

class SubmitWoooApplicationEvent extends SubmitWoooApprovalEvent {
  final String status;
  final String employeeWoooId;

  const SubmitWoooApplicationEvent({
    required this.status,
    required this.employeeWoooId,
  });

  @override
  List<Object> get props => [status, employeeWoooId];
}
