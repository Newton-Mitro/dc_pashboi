part of 'submit_wooo_application_bloc.dart';

sealed class SubmitWoooApplicationState extends Equatable {
  const SubmitWoooApplicationState();

  @override
  List<Object> get props => [];
}

final class SubmitWoooApplicationInitial extends SubmitWoooApplicationState {
  const SubmitWoooApplicationInitial();
}

final class SubmitWoooApplicationLoading extends SubmitWoooApplicationState {
  const SubmitWoooApplicationLoading();
}

final class SubmitWoooApplicationSuccess extends SubmitWoooApplicationState {
  final String message;

  const SubmitWoooApplicationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class SubmitWoooApplicationError extends SubmitWoooApplicationState {
  final String message;

  const SubmitWoooApplicationError(this.message);

  @override
  List<Object> get props => [message];
}
