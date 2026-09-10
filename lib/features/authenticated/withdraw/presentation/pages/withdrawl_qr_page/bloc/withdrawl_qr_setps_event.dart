part of 'withdrawl_qr_steps_bloc.dart';

abstract class WithdrawlQrStepsEvent extends Equatable {
  const WithdrawlQrStepsEvent();

  @override
  List<Object?> get props => [];
}

class WithdrawlQrGoToNextStep extends WithdrawlQrStepsEvent {
  const WithdrawlQrGoToNextStep();
}

class WithdrawlQrValidateStep extends WithdrawlQrStepsEvent {
  final int step;

  const WithdrawlQrValidateStep(this.step);

  @override
  List<Object?> get props => [step];
}

class WithdrawlQrGoToPreviousStep extends WithdrawlQrStepsEvent {
  const WithdrawlQrGoToPreviousStep();
}

class WithdrawlQrUpdateStepData extends WithdrawlQrStepsEvent {
  final int step;
  final Map<String, dynamic> data;

  const WithdrawlQrUpdateStepData({required this.step, required this.data});

  @override
  List<Object?> get props => [step, data];
}

class WithdrawlQrSelectCardAccount extends WithdrawlQrStepsEvent {
  final DepositAccountEntity selectedCardAccount;

  const WithdrawlQrSelectCardAccount(this.selectedCardAccount);

  @override
  List<Object?> get props => [selectedCardAccount];
}

class WithdrawlQrSelectDebitCard extends WithdrawlQrStepsEvent {
  final DebitCardEntity selectedCard;

  const WithdrawlQrSelectDebitCard(this.selectedCard);

  @override
  List<Object?> get props => [selectedCard];
}

class WithdrawlQrSubmit extends WithdrawlQrStepsEvent {
  final double withdrawAmount;

  const WithdrawlQrSubmit(this.withdrawAmount);

  @override
  List<Object?> get props => [withdrawAmount];
}
