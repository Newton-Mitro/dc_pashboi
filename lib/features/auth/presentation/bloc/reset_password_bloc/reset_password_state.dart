part of 'reset_password_bloc.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess();
}

class ResetPasswordValidationError extends ResetPasswordState {
  final Map<String, dynamic> errors;

  const ResetPasswordValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;

  const ResetPasswordFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class RegisteredMobileLoaded extends ResetPasswordState {
  final String mobile;

  const RegisteredMobileLoaded(this.mobile);

  @override
  List<Object?> get props => [mobile];
}
