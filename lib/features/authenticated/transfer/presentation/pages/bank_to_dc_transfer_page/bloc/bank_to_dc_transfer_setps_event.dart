part of 'bank_to_dc_transfer_steps_bloc.dart';

abstract class BankToDcTransferStepsEvent extends Equatable {
  const BankToDcTransferStepsEvent();

  @override
  List<Object?> get props => [];
}

class BankToDcTransferGoToNextStep extends BankToDcTransferStepsEvent {
  const BankToDcTransferGoToNextStep();
}

class BankToDcTransferValidateStep extends BankToDcTransferStepsEvent {
  final int step;

  const BankToDcTransferValidateStep(this.step);

  @override
  List<Object?> get props => [step];
}

class BankToDcTransferGoToPreviousStep extends BankToDcTransferStepsEvent {
  const BankToDcTransferGoToPreviousStep();
}

class BankToDcTransferUpdateStepData extends BankToDcTransferStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const BankToDcTransferUpdateStepData({
    required this.step,
    required this.data,
  });

  @override
  List<Object?> get props => [step, data];
}

class BankToDcTransferSetCollectionLedgers extends BankToDcTransferStepsEvent {
  final CollectionLedgerEntity ledger;

  const BankToDcTransferSetCollectionLedgers({required this.ledger});

  @override
  List<Object?> get props => [ledger];
}

// class BankToDcTransferToggleLedgerSelection extends BankToDcTransferStepsEvent {
//   final CollectionLedgerEntity ledger;

//   const BankToDcTransferToggleLedgerSelection(this.ledger);

//   @override
//   List<Object> get props => [ledger];
// }

// class BankToDcTransferToggleSelectAllLedgers
//     extends BankToDcTransferStepsEvent {
//   final bool selectAll;

//   const BankToDcTransferToggleSelectAllLedgers(this.selectAll);

//   @override
//   List<Object> get props => [selectAll];
// }

// class BankToDcTransferUpdateLedgerAmount extends BankToDcTransferStepsEvent {
//   final CollectionLedgerEntity ledger;
//   final double newAmount;

//   const BankToDcTransferUpdateLedgerAmount({
//     required this.ledger,
//     required this.newAmount,
//   });

//   @override
//   List<Object> get props => [ledger, newAmount];
// }

// class BankToDcTransferUpdateLpsAmount extends BankToDcTransferStepsEvent {
//   final String loanNumber;
//   final double newAmount;

//   const BankToDcTransferUpdateLpsAmount({
//     required this.loanNumber,
//     required this.newAmount,
//   });

//   @override
//   List<Object> get props => [loanNumber, newAmount];
// }

class BankToDcTransferSelectCardAccount extends BankToDcTransferStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const BankToDcTransferSelectCardAccount(this.selectedCardAccount);

  @override
  List<Object?> get props => [selectedCardAccount];
}

class BankToDcTransferSelectDebitCard extends BankToDcTransferStepsEvent {
  final DebitCardEntity selectedCard;

  const BankToDcTransferSelectDebitCard(this.selectedCard);

  @override
  List<Object?> get props => [selectedCard];
}

class BankToDcTransferSelectBankAccount extends BankToDcTransferStepsEvent {
  final DcBankEntity selectedBankAccount;

  const BankToDcTransferSelectBankAccount(this.selectedBankAccount);

  @override
  List<Object?> get props => [selectedBankAccount];
}

class BankToDcTransferSubmit extends BankToDcTransferStepsEvent {
  const BankToDcTransferSubmit();
}
