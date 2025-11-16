part of 'deposit_later_steps_bloc.dart';

abstract class DepositLaterStepsEvent extends Equatable {
  const DepositLaterStepsEvent();

  @override
  List<Object> get props => [];
}

class DepositLaterGoToNextStep extends DepositLaterStepsEvent {}

class DepositLaterValidateStep extends DepositLaterStepsEvent {
  final int step;

  const DepositLaterValidateStep(this.step);

  @override
  List<Object> get props => [step];
}

class DepositLaterGoToPreviousStep extends DepositLaterStepsEvent {}

class DepositLaterUpdateStepData extends DepositLaterStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const DepositLaterUpdateStepData({required this.step, required this.data});

  @override
  List<Object> get props => [step, data];
}

class DepositLaterSetCollectionLedgers extends DepositLaterStepsEvent {
  final List<CollectionLedgerEntity> ledgers;

  const DepositLaterSetCollectionLedgers({required this.ledgers});

  @override
  List<Object> get props => [ledgers];
}

class DepoistLaterToggleLedgerSelection extends DepositLaterStepsEvent {
  final CollectionLedgerEntity ledger;

  const DepoistLaterToggleLedgerSelection(this.ledger);

  @override
  List<Object> get props => [ledger];
}

class DepositLaterToggleSelectAllLedgers extends DepositLaterStepsEvent {
  final bool selectAll;

  const DepositLaterToggleSelectAllLedgers(this.selectAll);

  @override
  List<Object> get props => [selectAll];
}

class DepositLaterUpdateLedgerAmount extends DepositLaterStepsEvent {
  final CollectionLedgerEntity ledger;
  final int newAmount;

  const DepositLaterUpdateLedgerAmount({
    required this.ledger,
    required this.newAmount,
  });

  @override
  List<Object> get props => [ledger, newAmount];
}

class DepositLaterUpdateLpsAmount extends DepositLaterStepsEvent {
  final String loanNumber;
  final int newAmount;

  const DepositLaterUpdateLpsAmount({
    required this.loanNumber,
    required this.newAmount,
  });

  @override
  List<Object> get props => [loanNumber, newAmount];
}

class DepositLaterSelectCardAccount extends DepositLaterStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const DepositLaterSelectCardAccount(this.selectedCardAccount);

  @override
  List<Object> get props => [selectedCardAccount];
}

class DepositLaterSelectDebitCard extends DepositLaterStepsEvent {
  final DebitCardEntity selectedCard;

  const DepositLaterSelectDebitCard(this.selectedCard);

  @override
  List<Object> get props => [selectedCard];
}

class DepositLaterFlowReset extends DepositLaterStepsEvent {}

class DepositLaterSubmit extends DepositLaterStepsEvent {}
