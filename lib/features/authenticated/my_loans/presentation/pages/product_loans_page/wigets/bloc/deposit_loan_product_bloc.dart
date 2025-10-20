import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';

part 'deposit_loan_product_event.dart';
part 'deposit_loan_product_state.dart';

class DepositLoanProductBloc
    extends Bloc<DepositLoanProductEvent, DepositLoanProductState> {
  static const int firstStep = 0;
  static const int lastStep = 4;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;

  DepositLoanProductBloc({required this.getAuthUserUseCase})
    : super(DepositLoanProductState(currentStep: 0)) {
    on<DepositProductLoanGoToNextStep>(_onGoToNextStep);
    on<DepositProductLoanGoToPreviousStep>(_onGoToPreviousStep);
    on<SelectCardAccount>(_onSelectCardAccount);
    on<SelectDebitCard>(_onSelectDebitCard);
    on<ResetInstantLoanFlow>(_onResetFlow);
    on<UpdateStepData>(_onUpdateStepData);
    on<DepositProductLoanValidateStep>(_onValidateStep);

    on<SetCollectionLedgers>(_onSetCollectionLedgers);
    on<ToggleLedgerSelection>(_onToggleLedgerSelection);
    on<UpdateLedgerAmount>(_onUpdateLedgerAmount);
  }

  void _onSetCollectionLedgers(
    SetCollectionLedgers event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final selectedLedgers =
        event.ledgers
            .map(
              (ledger) => ledger.copyWith(
                accountNumber: ledger.accountNumber,
                accountTypeCode: ledger.accountTypeCode,
                amount: ledger.amount,
                loanBalance: ledger.loanBalance,
                intrestRate: ledger.intrestRate,

                isSelected: false,
              ),
            )
            .toList();
    emit(state.copyWith(collectionLedgers: selectedLedgers));
  }

  void _onToggleLedgerSelection(
    ToggleLedgerSelection event,
    Emitter<DepositLoanProductState> emit,
  ) {
    late List<CollectionLedgerEntity> updatedLedgers;

    updatedLedgers =
        state.collectionLedgers.map((l) {
          if (l.accountNumber == event.ledger.accountNumber) {
            return l.copyWith(isSelected: !(l.isSelected!));
          }
          return l;
        }).toList();

    emit(state.copyWith(collectionLedgers: [...updatedLedgers]));
  }

  void _onUpdateLedgerAmount(
    UpdateLedgerAmount event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final updatedLedgers =
        state.collectionLedgers.map((l) {
          if (l.accountNumber == event.ledger.accountNumber) {
            return l.copyWith(loanBalance: event.newAmount);
          }
          return l;
        }).toList();

    emit(state.copyWith(collectionLedgers: updatedLedgers));
  }

  void _onValidateStep(
    DepositProductLoanValidateStep event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final step = event.step;

    final errors = _validateInstantLoanSteps(step);

    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );

    updatedValidationErrors[step] = errors;

    emit(state.copyWith(validationErrors: updatedValidationErrors));
  }

  void _onUpdateStepData(
    UpdateStepData event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onResetFlow(
    ResetInstantLoanFlow event,
    Emitter<DepositLoanProductState> emit,
  ) {
    emit(const DepositLoanProductState(currentStep: 0));
  }

  void _onSelectCardAccount(
    SelectCardAccount event,
    Emitter<DepositLoanProductState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    SelectDebitCard event,
    Emitter<DepositLoanProductState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onGoToNextStep(
    DepositProductLoanGoToNextStep event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final step = state.currentStep;
    final errors = _validateInstantLoanSteps(step);

    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );
    updatedValidationErrors[step] = errors;

    if (errors.isEmpty && step < lastStep) {
      emit(
        state.copyWith(
          currentStep: step + 1,
          validationErrors: updatedValidationErrors,
        ),
      );
    } else {
      emit(state.copyWith(validationErrors: updatedValidationErrors));
    }
  }

  void _onGoToPreviousStep(
    DepositProductLoanGoToPreviousStep event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final current = state.currentStep;
    if (current > firstStep) {
      emit(state.copyWith(currentStep: current - 1));
    }
  }

  Map<String, dynamic> _validateInstantLoanSteps(int step) {
    final data = state.stepData[step] ?? {};
    final errors = <String, dynamic>{};

    switch (step) {
      case 0:
        // if (state.selectedAccount == null ||
        //     state.selectedAccount!.number.isEmpty) {
        //   errors['transferFromAccount'] = 'Select an account to transfer from';
        // }
        break;

      case 1:
        // if (data['amount'] == null ||
        //     data['amount'].toString().trim().isEmpty) {
        //   errors['amount'] = 'Please enter amount.';
        // } else {
        //   final fieldValue = data['amount'].toString().trim();

        //   final parsedAmount = double.tryParse(fieldValue);
        //   final loanAmount = 50000;

        //   if (parsedAmount == null || parsedAmount <= 0) {
        //     errors['amount'] = 'Please enter valid amount';
        //   } else if (parsedAmount <= 10000) {
        //     if (parsedAmount % 500 != 0) {
        //       errors['amount'] = 'Amount must be multiplied by 500 /-';
        //     } else if (parsedAmount > loanAmount) {
        //       errors['amount'] = 'Amount must be less than $loanAmount /-';
        //     }
        //   } else {
        //     if (parsedAmount % 1000 != 0) {
        //       errors['amount'] = 'Amount must be multiplied by 1000 /-';
        //     } else if (parsedAmount > loanAmount) {
        //       errors['amount'] = 'Amount must be less than $loanAmount /-';
        //     }
        //   }
        // }

        break;

      case 2:
        if (state.selectedAccount == null ||
            state.selectedAccount!.number.isEmpty) {
          errors['transferFromAccount'] = 'Select an account to transfer from';
        }
        break;

      case 3:
        if (data['cardPin'] == null || data['cardPin'].toString().isEmpty) {
          errors['cardPin'] = 'Please enter a card PIN';
        } else if (data['cardPin'].length != 4) {
          errors['cardPin'] = 'PIN must be 4 digits';
        }
        break;

      case 4:
        if (data['confirmation'] != true) {
          errors['confirmation'] = 'You must confirm to proceed';
        }
        break;

      // No validation needed for final review/step 5
      default:
        break;
    }

    return errors;
  }
}
