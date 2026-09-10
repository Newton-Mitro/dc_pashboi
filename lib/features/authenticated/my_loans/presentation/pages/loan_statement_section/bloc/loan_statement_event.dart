part of 'loan_statement_bloc.dart';

sealed class LoanStatementEvent extends Equatable {
  const LoanStatementEvent();

  @override
  List<Object?> get props => [];
}

class FetchLoanStatementEvent extends LoanStatementEvent {
  final String loanNumber;
  final String fromDate;
  final String toDate;
  const FetchLoanStatementEvent({
    required this.loanNumber,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [loanNumber, fromDate, toDate];
}
