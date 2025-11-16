part of 'deposit_now_steps_bloc.dart';

abstract class DepositNowStepsEvent extends Equatable {
  const DepositNowStepsEvent();

  @override
  List<Object> get props => [];
}

class DepositNowGoToNextStep extends DepositNowStepsEvent {}

class DepositNowValidateStep extends DepositNowStepsEvent {
  final int step;

  const DepositNowValidateStep(this.step);

  @override
  List<Object> get props => [step];
}

class DepositNowGoToPreviousStep extends DepositNowStepsEvent {}

class UpdateStepData extends DepositNowStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const UpdateStepData({required this.step, required this.data});

  @override
  List<Object> get props => [step, data];
}

class SetCollectionLedgers extends DepositNowStepsEvent {
  final List<CollectionLedgerEntity> ledgers;

  const SetCollectionLedgers({required this.ledgers});

  @override
  List<Object> get props => [ledgers];
}

class ToggleLedgerSelection extends DepositNowStepsEvent {
  final CollectionLedgerEntity ledger;

  const ToggleLedgerSelection(this.ledger);

  @override
  List<Object> get props => [ledger];
}

class ToggleSelectAllLedgers extends DepositNowStepsEvent {
  final bool selectAll;

  const ToggleSelectAllLedgers(this.selectAll);

  @override
  List<Object> get props => [selectAll];
}

class UpdateLedgerAmount extends DepositNowStepsEvent {
  final CollectionLedgerEntity ledger;
  final int newAmount;

  const UpdateLedgerAmount({required this.ledger, required this.newAmount});

  @override
  List<Object> get props => [ledger, newAmount];
}

class UpdateLpsAmount extends DepositNowStepsEvent {
  final String loanNumber;
  final int newAmount;

  const UpdateLpsAmount({required this.loanNumber, required this.newAmount});

  @override
  List<Object> get props => [loanNumber, newAmount];
}

class SelectCardAccount extends DepositNowStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const SelectCardAccount(this.selectedCardAccount);

  @override
  List<Object> get props => [selectedCardAccount];
}

class SelectDebitCard extends DepositNowStepsEvent {
  final DebitCardEntity selectedCard;

  const SelectDebitCard(this.selectedCard);

  @override
  List<Object> get props => [selectedCard];
}

class ResetDepositNowFlow extends DepositNowStepsEvent {}

class SubmitDepositNow extends DepositNowStepsEvent {}
