part of 'registration_page_bloc.dart';

sealed class RegistrationPageState extends Equatable {
  const RegistrationPageState();

  @override
  List<Object?> get props => [];
}

final class RegistrationInitialState extends RegistrationPageState {
  const RegistrationInitialState();
}

final class RegistrationLoadingState extends RegistrationPageState {
  const RegistrationLoadingState();
}

final class RegistrationSuccessState extends RegistrationPageState {
  final String data;
  const RegistrationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

final class RegistrationErrorState extends RegistrationPageState {
  final String message;
  const RegistrationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

final class RegistrationValidationErrorState extends RegistrationPageState {
  final Map<String, dynamic> errors;
  const RegistrationValidationErrorState(this.errors);

  @override
  List<Object?> get props => [errors];
}
