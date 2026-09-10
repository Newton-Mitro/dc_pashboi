part of 'account_statement_bloc.dart';

sealed class AccountStatementEvent extends Equatable {
  const AccountStatementEvent();

  @override
  List<Object?> get props => [];
}

class FetchAccountStatementEvent extends AccountStatementEvent {
  final String accountNumber;
  final String fromDate;
  final String toDate;
  const FetchAccountStatementEvent({
    required this.accountNumber,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [accountNumber, fromDate, toDate];
}
