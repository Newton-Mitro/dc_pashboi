part of 'fetch_against_loan_interest_bloc.dart';

sealed class FetchAgainstLoanInterestEvent extends Equatable {
  const FetchAgainstLoanInterestEvent();

  @override
  List<Object> get props => [];
}

class FetchAgainstLoanInterest extends FetchAgainstLoanInterestEvent {
  final String productCode;
  final String accountIds;

  const FetchAgainstLoanInterest({
    required this.productCode,
    required this.accountIds,
  });

  @override
  List<Object> get props => [productCode, accountIds];
}
