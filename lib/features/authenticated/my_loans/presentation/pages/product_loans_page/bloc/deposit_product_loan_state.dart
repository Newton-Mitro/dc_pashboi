part of 'deposit_product_loan_bloc.dart';

sealed class DepositProductLoanState extends Equatable {
  const DepositProductLoanState();

  @override
  List<Object> get props => [];
}

final class DepositProductLoanInitial extends DepositProductLoanState {}

final class DepositProductLoanLoading extends DepositProductLoanState {
  const DepositProductLoanLoading();
}

final class DepositProductLoanSuccess extends DepositProductLoanState {
  final List<DepositLoanEligibilityDto> depositLoanEligibilityDto;

  const DepositProductLoanSuccess(this.depositLoanEligibilityDto);

  @override
  List<Object> get props => [depositLoanEligibilityDto];
}

final class DepositProductLoanError extends DepositProductLoanState {
  final String message;

  const DepositProductLoanError(this.message);

  @override
  List<Object> get props => [message];
}
