part of 'internal_transfer_steps_bloc.dart';

abstract class InternalTransferStepsEvent extends Equatable {
  const InternalTransferStepsEvent();

  @override
  List<Object?> get props => [];
}

class InternalTransferGoToNextStep extends InternalTransferStepsEvent {
  const InternalTransferGoToNextStep();
}

class InternalTransferValidateStep extends InternalTransferStepsEvent {
  final int step;

  const InternalTransferValidateStep(this.step);

  @override
  List<Object?> get props => [step];
}

class InternalTransferGoToPreviousStep extends InternalTransferStepsEvent {
  const InternalTransferGoToPreviousStep();
}

class InternalTransferUpdateStepData extends InternalTransferStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const InternalTransferUpdateStepData({
    required this.step,
    required this.data,
  });

  @override
  List<Object?> get props => [step, data];
}

class InternalTransferSelectCardAccount extends InternalTransferStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const InternalTransferSelectCardAccount(this.selectedCardAccount);

  @override
  List<Object?> get props => [selectedCardAccount];
}

class InternalTransferSelectDebitCard extends InternalTransferStepsEvent {
  final DebitCardEntity selectedCard;

  const InternalTransferSelectDebitCard(this.selectedCard);

  @override
  List<Object?> get props => [selectedCard];
}

class InternalTransferSubmit extends InternalTransferStepsEvent {
  final String toAccountNumber;
  final double transferAmount;

  const InternalTransferSubmit({
    required this.toAccountNumber,
    required this.transferAmount,
  });

  @override
  List<Object?> get props => [toAccountNumber, transferAmount];
}
