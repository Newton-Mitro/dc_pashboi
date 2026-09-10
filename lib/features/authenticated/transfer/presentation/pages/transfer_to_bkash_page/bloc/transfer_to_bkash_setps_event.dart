part of 'transfer_to_bkash_steps_bloc.dart';

abstract class TransferToBkashStepsEvent extends Equatable {
  const TransferToBkashStepsEvent();

  @override
  List<Object?> get props => [];
}

class TransferToBkashGoToNextStep extends TransferToBkashStepsEvent {
  const TransferToBkashGoToNextStep();
}

class TransferToBkashValidateStep extends TransferToBkashStepsEvent {
  final int step;

  const TransferToBkashValidateStep(this.step);

  @override
  List<Object?> get props => [step];
}

class TransferToBkashGoToPreviousStep extends TransferToBkashStepsEvent {
  const TransferToBkashGoToPreviousStep();
}

class TransferToBkashUpdateStepData extends TransferToBkashStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const TransferToBkashUpdateStepData({required this.step, required this.data});

  @override
  List<Object?> get props => [step, data];
}

class TransferToBkashSelectCardAccount extends TransferToBkashStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const TransferToBkashSelectCardAccount(this.selectedCardAccount);

  @override
  List<Object?> get props => [selectedCardAccount];
}

class TransferToBkashSelectDebitCard extends TransferToBkashStepsEvent {
  final DebitCardEntity selectedCard;

  const TransferToBkashSelectDebitCard(this.selectedCard);

  @override
  List<Object?> get props => [selectedCard];
}

class TransferToBkashSubmit extends TransferToBkashStepsEvent {
  const TransferToBkashSubmit();
}

class TransferToBkashLoadUser extends TransferToBkashStepsEvent {
  const TransferToBkashLoadUser();
}
