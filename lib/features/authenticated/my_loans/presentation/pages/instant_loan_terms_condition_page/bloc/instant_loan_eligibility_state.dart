part of 'instant_loan_eligibility_bloc.dart';

sealed class InstantLoanEligibilityState extends Equatable {
  const InstantLoanEligibilityState();

  @override
  List<Object> get props => [];
}

final class InstantLoanEligibilityInitial extends InstantLoanEligibilityState {
  const InstantLoanEligibilityInitial();
}

final class InstantLoanEligibilityLoading extends InstantLoanEligibilityState {
  const InstantLoanEligibilityLoading();
}

final class InstantLoanEligibilitySuccess extends InstantLoanEligibilityState {
  final InstantLoanEligibilityDTO instantLoanEligibilityDTO;

  const InstantLoanEligibilitySuccess(this.instantLoanEligibilityDTO);

  @override
  List<Object> get props => [instantLoanEligibilityDTO];
}

final class InstantLoanEligibilityError extends InstantLoanEligibilityState {
  final String message;

  const InstantLoanEligibilityError(this.message);

  @override
  List<Object> get props => [message];
}
