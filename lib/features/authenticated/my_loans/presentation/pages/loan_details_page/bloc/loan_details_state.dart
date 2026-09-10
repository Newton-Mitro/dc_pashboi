part of 'loan_details_bloc.dart';

sealed class LoanDetailsState extends Equatable {
  const LoanDetailsState();

  @override
  List<Object?> get props => [];
}

final class LoanDetailsInitial extends LoanDetailsState {
  const LoanDetailsInitial();
}

final class LoanDetsilsLoading extends LoanDetailsState {
  const LoanDetsilsLoading();
}

final class LoanDetailsSuccess extends LoanDetailsState {
  final LoanAccountEntity loan;

  const LoanDetailsSuccess(this.loan);

  @override
  List<Object?> get props => [loan];
}

final class LoanDetailsError extends LoanDetailsState {
  final String error;
  const LoanDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}
