part of 'otp_verification_bloc.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class OtpChanged extends OtpVerificationEvent {
  final String otp;

  const OtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class VerifyOtpSubmitted extends OtpVerificationEvent {
  final String mobileNumber;
  final String otp;
  final String otpRegId;

  const VerifyOtpSubmitted({
    required this.mobileNumber,
    required this.otp,
    required this.otpRegId,
  });

  @override
  List<Object?> get props => [mobileNumber, otp, otpRegId];
}
