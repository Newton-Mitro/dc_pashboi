part of 'my_loans_bloc.dart';

sealed class MyLoansState extends Equatable {
  const MyLoansState();

  @override
  List<Object?> get props => [];
}

final class MyLoansInitial extends MyLoansState {
  const MyLoansInitial();
}

final class MyLoansLoading extends MyLoansState {
  const MyLoansLoading();
}

final class MyLoansLoaded extends MyLoansState {
  final List<LoanAccountEntity> loans;

  const MyLoansLoaded(this.loans);

  @override
  List<Object?> get props => [loans];
}

final class MyLoansError extends MyLoansState {
  final String error;
  const MyLoansError(this.error);

  @override
  List<Object?> get props => [error];
}
