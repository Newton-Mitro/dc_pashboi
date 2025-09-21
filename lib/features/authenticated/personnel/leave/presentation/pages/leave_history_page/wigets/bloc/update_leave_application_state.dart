part of 'update_leave_application_bloc.dart';

sealed class UpdateLeaveApplicationState extends Equatable {
  const UpdateLeaveApplicationState();

  @override
  List<Object> get props => [];
}

final class UpdateLeaveApplicationInitial extends UpdateLeaveApplicationState {
  const UpdateLeaveApplicationInitial();
}

final class UpdateLeaveApplicationLoading extends UpdateLeaveApplicationState {
  const UpdateLeaveApplicationLoading();
}

final class UpdateLeaveApplicationSuccess extends UpdateLeaveApplicationState {
  final String message;

  const UpdateLeaveApplicationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateLeaveApplicationError extends UpdateLeaveApplicationState {
  final String message;

  const UpdateLeaveApplicationError(this.message);

  @override
  List<Object> get props => [message];
}
