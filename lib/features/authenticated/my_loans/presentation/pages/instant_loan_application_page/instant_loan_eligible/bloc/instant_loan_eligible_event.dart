part of 'instant_loan_eligible_bloc.dart';

sealed class InstantLoanEligibleEvent extends Equatable {
  const InstantLoanEligibleEvent();

  @override
  List<Object> get props => [];
}

class InstantLoanGoToNextStep extends InstantLoanEligibleEvent {}

class InstantLoanValidateStep extends InstantLoanEligibleEvent {
  final int step;

  const InstantLoanValidateStep(this.step);

  @override
  List<Object> get props => [step];
}

class InstantLoanGoToPreviousStep extends InstantLoanEligibleEvent {}

class UpdateStepData extends InstantLoanEligibleEvent {
  final int step;
  final Map<String, dynamic> data;

  const UpdateStepData({required this.step, required this.data});

  @override
  List<Object> get props => [step, data];
}

class SelectDebitCard extends InstantLoanEligibleEvent {
  final DebitCardEntity selectedCard;

  const SelectDebitCard(this.selectedCard);

  @override
  List<Object> get props => [selectedCard];
}

class SelectCardAccount extends InstantLoanEligibleEvent {
  final DepositAccountEntity selectedCardAccount;

  const SelectCardAccount(this.selectedCardAccount);

  @override
  List<Object> get props => [selectedCardAccount];
}

class ResetInstantLoanFlow extends InstantLoanEligibleEvent {}

class SubmitInstantLoan extends InstantLoanEligibleEvent {
  final String moduleCode;

  const SubmitInstantLoan(this.moduleCode);

  @override
  List<Object> get props => [moduleCode];
}
