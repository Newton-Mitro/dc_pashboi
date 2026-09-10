part of 'loan_payment_bloc.dart';

sealed class LoanPaymentState extends Equatable {
  const LoanPaymentState();

  @override
  List<Object?> get props => [];
}

final class LoanPaymentInitial extends LoanPaymentState {
  const LoanPaymentInitial();
}

class LoanPaymentLoading extends LoanPaymentState {
  const LoanPaymentLoading();
}

class LoanPaymentLoaded extends LoanPaymentState {
  final LoanPaymentEntity loanPayment;

  const LoanPaymentLoaded({required this.loanPayment});

  @override
  List<Object?> get props => [loanPayment];
}

class LoanPaymentError extends LoanPaymentState {
  final String message;

  const LoanPaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}
