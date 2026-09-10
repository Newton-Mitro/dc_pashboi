part of 'loan_policy_bloc.dart';

sealed class LoanPolicyEvent extends Equatable {
  const LoanPolicyEvent();

  @override
  List<Object?> get props => [];
}

class FetchLoanPolicyEvent extends LoanPolicyEvent {
  const FetchLoanPolicyEvent();
}
