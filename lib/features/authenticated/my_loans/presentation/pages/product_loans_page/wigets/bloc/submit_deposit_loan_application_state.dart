part of 'submit_deposit_loan_application_bloc.dart';

sealed class SubmitDepositLoanApplicationState extends Equatable {
  const SubmitDepositLoanApplicationState();
  
  @override
  List<Object> get props => [];
}

final class SubmitDepositLoanApplicationInitial extends SubmitDepositLoanApplicationState {}
