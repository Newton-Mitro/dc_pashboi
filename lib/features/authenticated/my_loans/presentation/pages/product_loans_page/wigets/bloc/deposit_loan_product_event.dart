part of 'deposit_loan_product_bloc.dart';

sealed class DepositLoanProductEvent extends Equatable {
  const DepositLoanProductEvent();

  @override
  List<Object> get props => [];
}

class DepositProductLoanGoToNextStep extends DepositLoanProductEvent {}

class DepositProductLoanValidateStep extends DepositLoanProductEvent {
  final int step;

  const DepositProductLoanValidateStep(this.step);

  @override
  List<Object> get props => [step];
}

class DepositProductLoanGoToPreviousStep extends DepositLoanProductEvent {}

class UpdateStepData extends DepositLoanProductEvent {
  final int step;
  final Map<String, dynamic> data;

  const UpdateStepData({required this.step, required this.data});

  @override
  List<Object> get props => [step, data];
}

class SetLoanAccounts extends DepositLoanProductEvent {
  final List<ProductLoanCollectionAccountEntity> ledgers;

  const SetLoanAccounts({required this.ledgers});

  @override
  List<Object> get props => [ledgers];
}

class ToggleAccountSelection extends DepositLoanProductEvent {
  final ProductLoanCollectionAccountEntity ledger;

  const ToggleAccountSelection(this.ledger);

  @override
  List<Object> get props => [ledger];
}

class UpdateLoanAccountAmount extends DepositLoanProductEvent {
  final ProductLoanCollectionAccountEntity ledger;
  final String newAmount;

  const UpdateLoanAccountAmount({
    required this.ledger,
    required this.newAmount,
  });

  @override
  List<Object> get props => [ledger, newAmount];
}

class SelectDebitCard extends DepositLoanProductEvent {
  final DebitCardEntity selectedCard;

  const SelectDebitCard(this.selectedCard);

  @override
  List<Object> get props => [selectedCard];
}

class SelectCardAccount extends DepositLoanProductEvent {
  final DepositAccountEntity selectedCardAccount;

  const SelectCardAccount(this.selectedCardAccount);

  @override
  List<Object> get props => [selectedCardAccount];
}

class ResetInstantLoanFlow extends DepositLoanProductEvent {}

class SubmitDepositLoanProduct extends DepositLoanProductEvent {}
