part of 'account_opening_steps_bloc.dart';

abstract class AccountOpeningStepsEvent extends Equatable {
  const AccountOpeningStepsEvent();

  @override
  List<Object> get props => [];
}

class AccountOpeningGoToNextStep extends AccountOpeningStepsEvent {}

class AccountOpeningValidateStep extends AccountOpeningStepsEvent {
  final int step;

  const AccountOpeningValidateStep(this.step);

  @override
  List<Object> get props => [step];
}

class AccountOpeningGoToPreviousStep extends AccountOpeningStepsEvent {}

class AccountOpeningUpdateStepData extends AccountOpeningStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const AccountOpeningUpdateStepData({required this.step, required this.data});

  @override
  List<Object> get props => [step, data];
}

class AccountOpeningSelectCardAccount extends AccountOpeningStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const AccountOpeningSelectCardAccount(this.selectedCardAccount);

  @override
  List<Object> get props => [selectedCardAccount];
}

class AccountOpeningSelectTenure extends AccountOpeningStepsEvent {
  final TenureEntity selectedTenure;

  const AccountOpeningSelectTenure(this.selectedTenure);

  @override
  List<Object> get props => [selectedTenure];
}

class AccountOpeningAddNominee extends AccountOpeningStepsEvent {
  final NomineeEntity nominee;

  const AccountOpeningAddNominee(this.nominee);

  @override
  List<Object> get props => [nominee];
}

class AccountOpeningRemoveNominee extends AccountOpeningStepsEvent {
  final NomineeEntity nominee;

  const AccountOpeningRemoveNominee(this.nominee);

  @override
  List<Object> get props => [nominee];
}

class AccountOpeningSelectTenureAmount extends AccountOpeningStepsEvent {
  final TenureAmountEntity selectedTenureAmount;

  const AccountOpeningSelectTenureAmount(this.selectedTenureAmount);

  @override
  List<Object> get props => [selectedTenureAmount];
}

class AccountOpeningSelectDebitCard extends AccountOpeningStepsEvent {
  final DebitCardEntity selectedCard;

  const AccountOpeningSelectDebitCard(this.selectedCard);

  @override
  List<Object> get props => [selectedCard];
}

class AccountOpeningFlowReset extends AccountOpeningStepsEvent {}

// class AccountOpeningSubmit extends AccountOpeningStepsEvent {}

class AccountOpeningSubmit extends AccountOpeningStepsEvent {
  final String productCode;

  const AccountOpeningSubmit({required this.productCode});

  @override
  List<Object> get props => [productCode];
}
