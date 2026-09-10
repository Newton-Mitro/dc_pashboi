part of 'otp_verification_bloc.dart';

abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();

  @override
  List<Object?> get props => [];
}

class OtpVerificationInitial extends OtpVerificationState {
  const OtpVerificationInitial();
}

class OtpVerificationLoading extends OtpVerificationState {
  const OtpVerificationLoading();
}

class OtpVerificationSuccess extends OtpVerificationState {
  final String message;

  const OtpVerificationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpVerificationFailure extends OtpVerificationState {
  final String error;

  const OtpVerificationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
