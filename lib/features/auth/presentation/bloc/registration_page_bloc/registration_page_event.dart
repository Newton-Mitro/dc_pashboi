part of 'registration_page_bloc.dart';

sealed class RegistrationPageEvent extends Equatable {
  const RegistrationPageEvent();

  @override
  List<Object?> get props => [];
}

final class RegisterEvent extends RegistrationPageEvent {
  final String password;
  final String email;
  final String confirmPassword;

  const RegisterEvent({
    required this.password,
    required this.email,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [password, email, confirmPassword];
}
