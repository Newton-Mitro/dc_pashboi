part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final AuthUserEntity authUser;

  const Authenticated(this.authUser);

  @override
  List<Object?> get props => [authUser];
}

class UnAuthenticated extends AuthState {
  const UnAuthenticated();
}

final class AuthValidationErrorState extends AuthState {
  final Map<String, dynamic> errors;
  const AuthValidationErrorState(this.errors);

  @override
  List<Object?> get props => [errors];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
