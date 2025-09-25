part of 'instant_loan_eligibility_bloc.dart';

sealed class InstantLoanEligibilityEvent extends Equatable {
  const InstantLoanEligibilityEvent();

  @override
  List<Object> get props => [];
}

class FetchInstantLoanEligibilityEvent extends InstantLoanEligibilityEvent {
  const FetchInstantLoanEligibilityEvent();
}
