part of 'fetch_against_loan_interest_bloc.dart';

sealed class FetchAgainstLoanInterestState extends Equatable {
  const FetchAgainstLoanInterestState();

  @override
  List<Object> get props => [];
}

final class FetchAgainstLoanInterestInitial
    extends FetchAgainstLoanInterestState {
  const FetchAgainstLoanInterestInitial();
}

final class FetchAgainstLoanInterestLoading
    extends FetchAgainstLoanInterestState {
  const FetchAgainstLoanInterestLoading();
}

final class FetchAgainstLoanInterestSuccess
    extends FetchAgainstLoanInterestState {
  final AgainstLoanInterestEntity againstLoanInterestEntity;

  const FetchAgainstLoanInterestSuccess(this.againstLoanInterestEntity);

  @override
  List<Object> get props => [againstLoanInterestEntity];
}

final class FetchAgainstLoanInterestError
    extends FetchAgainstLoanInterestState {
  final String message;

  const FetchAgainstLoanInterestError(this.message);

  @override
  List<Object> get props => [message];
}
