part of 'payment_steps_bloc.dart';

abstract class PaymentStepsEvent extends Equatable {
  const PaymentStepsEvent();

  @override
  List<Object?> get props => [];
}

class PaymentGoToNextStep extends PaymentStepsEvent {
  const PaymentGoToNextStep();
}

class PaymentValidateStep extends PaymentStepsEvent {
  final int step;

  const PaymentValidateStep(this.step);

  @override
  List<Object?> get props => [step];
}

class PaymentGoToPreviousStep extends PaymentStepsEvent {
  const PaymentGoToPreviousStep();
}

class PaymentUpdateStepData extends PaymentStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const PaymentUpdateStepData({required this.step, required this.data});

  @override
  List<Object?> get props => [step, data];
}

class PaymentSelectCardAccount extends PaymentStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const PaymentSelectCardAccount(this.selectedCardAccount);

  @override
  List<Object?> get props => [selectedCardAccount];
}

class PaymentSelectDebitCard extends PaymentStepsEvent {
  final DebitCardEntity selectedCard;

  const PaymentSelectDebitCard(this.selectedCard);

  @override
  List<Object?> get props => [selectedCard];
}

class PaymentSubmit extends PaymentStepsEvent {
  const PaymentSubmit();
}
