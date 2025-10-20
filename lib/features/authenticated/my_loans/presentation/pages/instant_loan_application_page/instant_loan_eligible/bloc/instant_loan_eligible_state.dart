part of 'instant_loan_eligible_bloc.dart';

class InstantLoanEligibleState extends Equatable {
  final int currentStep;
  final Map<int, Map<String, dynamic>> validationErrors;
  final Map<int, Map<String, dynamic>> stepData;
  final DepositAccountEntity? selectedAccount;
  final DebitCardEntity? selectedCard;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const InstantLoanEligibleState({
    required this.currentStep,
    this.validationErrors = const {},
    this.stepData = const {},
    this.selectedAccount,
    this.selectedCard,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  InstantLoanEligibleState copyWith({
    int? currentStep,
    Map<int, Map<String, dynamic>>? validationErrors,
    Map<int, Map<String, dynamic>>? stepData,
    bool? isLoading,
    String? error,
    String? successMessage,
    DepositAccountEntity? selectedAccount,
    DebitCardEntity? selectedCard,
  }) {
    return InstantLoanEligibleState(
      currentStep: currentStep ?? this.currentStep,
      validationErrors: validationErrors ?? this.validationErrors,
      stepData: stepData ?? this.stepData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    validationErrors,
    stepData,
    isLoading,
    error,
    successMessage,
    selectedAccount,
    selectedCard,
  ];
}
