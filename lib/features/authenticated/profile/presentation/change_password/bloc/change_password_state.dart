part of 'change_password_bloc.dart';

sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

final class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

final class ChangePasswordLoading extends ChangePasswordState {
  const ChangePasswordLoading();
}

final class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  const ChangePasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class ChangePasswordError extends ChangePasswordState {
  final String message;

  const ChangePasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ChangePasswordValidationError extends ChangePasswordState {
  final Map<String, String> errors;

  const ChangePasswordValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}
