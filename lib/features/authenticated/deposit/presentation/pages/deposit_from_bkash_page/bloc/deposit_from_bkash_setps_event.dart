part of 'deposit_from_bkash_steps_bloc.dart';

abstract class DepositFromBkashStepsEvent extends Equatable {
  const DepositFromBkashStepsEvent();

  @override
  List<Object> get props => [];
}

class DepositFromBkashGoToNextStep extends DepositFromBkashStepsEvent {}

class DepositFromBkashValidateStep extends DepositFromBkashStepsEvent {
  final int step;

  const DepositFromBkashValidateStep(this.step);

  @override
  List<Object> get props => [step];
}

class DepositFromBkashGoToPreviousStep extends DepositFromBkashStepsEvent {}

class DepositFromBkashUpdateStepData extends DepositFromBkashStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const DepositFromBkashUpdateStepData({
    required this.step,
    required this.data,
  });

  @override
  List<Object> get props => [step, data];
}

class DepositFromBkashSetCollectionLedgers extends DepositFromBkashStepsEvent {
  final List<CollectionLedgerEntity> ledgers;

  const DepositFromBkashSetCollectionLedgers({required this.ledgers});

  @override
  List<Object> get props => [ledgers];
}

class DepositFromBkashToggleLedgerSelection extends DepositFromBkashStepsEvent {
  final CollectionLedgerEntity ledger;

  const DepositFromBkashToggleLedgerSelection(this.ledger);

  @override
  List<Object> get props => [ledger];
}

class DepositFromBkashToggleSelectAllLedgers
    extends DepositFromBkashStepsEvent {
  final bool selectAll;

  const DepositFromBkashToggleSelectAllLedgers(this.selectAll);

  @override
  List<Object> get props => [selectAll];
}

class DepositFromBkashUpdateLedgerAmount extends DepositFromBkashStepsEvent {
  final CollectionLedgerEntity ledger;
  final int newAmount;

  const DepositFromBkashUpdateLedgerAmount({
    required this.ledger,
    required this.newAmount,
  });

  @override
  List<Object> get props => [ledger, newAmount];
}

class DepositFromBkashUpdateLpsAmount extends DepositFromBkashStepsEvent {
  final String loanNumber;
  final int newAmount;

  const DepositFromBkashUpdateLpsAmount({
    required this.loanNumber,
    required this.newAmount,
  });

  @override
  List<Object> get props => [loanNumber, newAmount];
}

class DepositFromBkashResetFlow extends DepositFromBkashStepsEvent {}

class DepositFromBkashSubmit extends DepositFromBkashStepsEvent {}
