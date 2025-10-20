part of 'deposit_product_loan_bloc.dart';

sealed class DepositProductLoanEvent extends Equatable {
  const DepositProductLoanEvent();

  @override
  List<Object> get props => [];
}

class FetchDepositLoanEligibilityEvent extends DepositProductLoanEvent {
  const FetchDepositLoanEligibilityEvent();
}
