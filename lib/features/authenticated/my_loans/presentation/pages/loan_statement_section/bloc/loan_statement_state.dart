part of 'loan_statement_bloc.dart';

sealed class LoanStatementState extends Equatable {
  const LoanStatementState();

  @override
  List<Object?> get props => [];
}

final class LoanStatementInitial extends LoanStatementState {
  const LoanStatementInitial();
}

final class LoanStatementLoading extends LoanStatementState {
  const LoanStatementLoading();
}

final class LoanStatementSuccess extends LoanStatementState {
  final List<LoanTransactionEntity> transactions;

  const LoanStatementSuccess(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

final class LoanStatementError extends LoanStatementState {
  final String error;
  const LoanStatementError(this.error);

  @override
  List<Object?> get props => [error];
}
