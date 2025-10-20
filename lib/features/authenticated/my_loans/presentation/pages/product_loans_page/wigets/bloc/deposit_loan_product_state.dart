part of 'deposit_loan_product_bloc.dart';

class DepositLoanProductState extends Equatable {
  final int currentStep;
  final Map<int, Map<String, dynamic>> validationErrors;
  final Map<int, Map<String, dynamic>> stepData;
  final DepositAccountEntity? selectedAccount;
  final DebitCardEntity? selectedCard;
  final List<CollectionLedgerEntity> collectionLedgers;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const DepositLoanProductState({
    required this.currentStep,
    this.validationErrors = const {},
    this.stepData = const {},
    this.selectedAccount,
    List<CollectionLedgerEntity>? collectionLedgers,
    this.selectedCard,
    this.isLoading = false,
    this.error,
    this.successMessage,
  }) : collectionLedgers = collectionLedgers ?? const [];

  DepositLoanProductState copyWith({
    int? currentStep,
    Map<int, Map<String, dynamic>>? validationErrors,
    Map<int, Map<String, dynamic>>? stepData,
    bool? isLoading,
    List<CollectionLedgerEntity>? collectionLedgers,
    String? error,
    String? successMessage,
    DepositAccountEntity? selectedAccount,
    DebitCardEntity? selectedCard,
  }) {
    return DepositLoanProductState(
      currentStep: currentStep ?? this.currentStep,
      validationErrors: validationErrors ?? this.validationErrors,
      stepData: stepData ?? this.stepData,
      collectionLedgers: collectionLedgers ?? this.collectionLedgers,
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
    collectionLedgers,
    stepData,
    isLoading,
    error,
    successMessage,
    selectedAccount,
    selectedCard,
  ];
}
