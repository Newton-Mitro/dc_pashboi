part of 'mobile_number_verification_bloc.dart';

abstract class VerifyMobileNumberState extends Equatable {
  const VerifyMobileNumberState();

  @override
  List<Object?> get props => [];
}

class VerifyMobileNumberInitial extends VerifyMobileNumberState {
  const VerifyMobileNumberInitial();
}

class VerifyMobileNumberLoading extends VerifyMobileNumberState {
  const VerifyMobileNumberLoading();
}

class VerifyMobileNumberSuccess extends VerifyMobileNumberState {
  final String message;

  const VerifyMobileNumberSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class VerifyMobileNumberFailure extends VerifyMobileNumberState {
  final String error;

  const VerifyMobileNumberFailure(this.error);

  @override
  List<Object?> get props => [error];
}
