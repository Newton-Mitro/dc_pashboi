part of 'loan_details_bloc.dart';

sealed class LoanDetsilsEvent extends Equatable {
  const LoanDetsilsEvent();

  @override
  List<Object?> get props => [];
}

class FetchLoanDetsilsEvent extends LoanDetsilsEvent {
  final String loanNumber;
  const FetchLoanDetsilsEvent({required this.loanNumber});

  @override
  List<Object?> get props => [loanNumber];
}
