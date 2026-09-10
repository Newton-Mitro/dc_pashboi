part of 'account_statement_bloc.dart';

sealed class AccountStatementState extends Equatable {
  const AccountStatementState();

  @override
  List<Object?> get props => [];
}

final class AccountStatementInitial extends AccountStatementState {
  const AccountStatementInitial();
}

final class AccountStatementLoading extends AccountStatementState {
  const AccountStatementLoading();
}

final class AccountStatementSuccess extends AccountStatementState {
  final List<AccountTransactionEntity> transactions;

  const AccountStatementSuccess(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

final class AccountStatementError extends AccountStatementState {
  final String error;
  const AccountStatementError(this.error);

  @override
  List<Object?> get props => [error];
}
