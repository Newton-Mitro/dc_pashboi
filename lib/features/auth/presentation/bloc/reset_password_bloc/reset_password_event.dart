part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordRequested extends ResetPasswordEvent {
  final String mobileNumber;
  final String password;

  const ResetPasswordRequested({
    required this.mobileNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [mobileNumber, password];
}

class GetRegisteredMobileRequested extends ResetPasswordEvent {
  const GetRegisteredMobileRequested();
}
