part of 'transfer_to_bkash_steps_bloc.dart';

class TransferToBkashStepsState extends Equatable {
  final int currentStep;
  final Map<int, Map<String, dynamic>> validationErrors;
  final Map<int, Map<String, dynamic>> stepData;
  final DepositAccountEntity? selectedAccount;
  final DebitCardEntity? selectedCard;
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final UserEntity? user;

  const TransferToBkashStepsState({
    required this.currentStep,
    this.selectedAccount,
    this.selectedCard,
    Map<int, Map<String, dynamic>>? validationErrors,
    Map<int, Map<String, dynamic>>? stepData,
    bool? isLoading,
    this.error,
    this.successMessage,
    this.user,
  }) : validationErrors = validationErrors ?? const {},
       stepData = stepData ?? const {},
       isLoading = isLoading ?? false;

  TransferToBkashStepsState copyWith({
    int? currentStep,
    Map<int, Map<String, dynamic>>? validationErrors,
    Map<int, Map<String, dynamic>>? stepData,
    DepositAccountEntity? selectedAccount,
    DebitCardEntity? selectedCard,
    bool? isLoading,
    String? error,
    String? successMessage,
    UserEntity? user,
  }) {
    return TransferToBkashStepsState(
      currentStep: currentStep ?? this.currentStep,
      validationErrors: validationErrors ?? this.validationErrors,
      stepData: stepData ?? this.stepData,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedCard: selectedCard ?? this.selectedCard,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    validationErrors,
    stepData,
    selectedAccount,
    selectedCard,
    isLoading,
    error,
    successMessage,
    user, // ✅ IMPORTANT FIX
  ];
}
