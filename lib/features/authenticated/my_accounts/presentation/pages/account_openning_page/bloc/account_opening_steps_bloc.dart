import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/nominee_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/tenure_amount_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/tenure_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/open_deposit_account_usecase.dart';
part 'account_opening_setps_event.dart';
part 'account_opening_steps_state.dart';

class AccountOpeningStepsBloc
    extends Bloc<AccountOpeningStepsEvent, AccountOpeningStepsState> {
  // Define step range constants
  static const int firstStep = 0;
  static const int lastStep = 6;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final OpenDepositAccountUseCase openDepositAccountUseCase;
  final AppLocalizationService appLocalizationService;

  AccountOpeningStepsBloc({
    required this.getAuthUserUseCase,
    required this.openDepositAccountUseCase,
    required this.appLocalizationService,
  }) : super(
         const AccountOpeningStepsState(
           currentStep: 0,
           stepData: {
             1: {"accountFor": "Personal"},
           },
         ),
       ) {
    on<AccountOpeningGoToNextStep>(_onGoToNextStep);
    on<AccountOpeningGoToPreviousStep>(_onGoToPreviousStep);
    on<AccountOpeningUpdateStepData>(_onUpdateStepData);
    on<AccountOpeningFlowReset>(_onResetFlow);
    on<AccountOpeningSelectCardAccount>(_onSelectCardAccount);
    on<AccountOpeningSelectDebitCard>(_onSelectDebitCard);
    on<AccountOpeningSelectTenure>(_onSelectTenure);
    on<AccountOpeningSelectTenureAmount>(_onSelectTenureAmount);
    on<AccountOpeningAddNominee>(_onAddNominee);
    on<AccountOpeningRemoveNominee>(_onRemoveNominee);
    // update lps amount
    on<AccountOpeningValidateStep>(_onValidateStep);
    on<AccountOpeningSubmit>(_onSubmitOpenAnAccount);
  }

  void _onGoToNextStep(
    AccountOpeningGoToNextStep event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    final step = state.currentStep;
    final errors = _validateDepositNowSteps(step);

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
    AccountOpeningGoToPreviousStep event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    AccountOpeningUpdateStepData event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onResetFlow(
    AccountOpeningFlowReset event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    emit(const AccountOpeningStepsState(currentStep: 0));
  }

  void _onSelectCardAccount(
    AccountOpeningSelectCardAccount event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    AccountOpeningSelectDebitCard event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onSelectTenure(
    AccountOpeningSelectTenure event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    emit(state.copyWith(selectedTenure: event.selectedTenure));
  }

  void _onSelectTenureAmount(
    AccountOpeningSelectTenureAmount event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    emit(state.copyWith(selectedTenureAmount: event.selectedTenureAmount));
  }

  void _onValidateStep(
    AccountOpeningValidateStep event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    final step = event.step;

    final errors = _validateDepositNowSteps(step);
    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );

    updatedValidationErrors[step] = errors;

    emit(state.copyWith(validationErrors: updatedValidationErrors));
  }

  void _onAddNominee(
    AccountOpeningAddNominee event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    final totalPercentage = state.nominees.fold<double>(
      0,
      (sum, nominee) => sum + (nominee.percentage ?? 0),
    );

    final newTotal = totalPercentage + (event.nominee.percentage ?? 0);

    if (newTotal > 100) {
      // Optionally emit error or use a side-effect to show a dialog/snackbar
      return;
    }

    final updatedNominees = List<NomineeEntity>.from(state.nominees)
      ..add(event.nominee);

    emit(state.copyWith(nominees: updatedNominees, validationErrors: {}));
  }

  void _onRemoveNominee(
    AccountOpeningRemoveNominee event,
    Emitter<AccountOpeningStepsState> emit,
  ) {
    final updatedNominees = List<NomineeEntity>.from(state.nominees)
      ..removeWhere((n) => n.id == event.nominee.id);
    emit(state.copyWith(nominees: updatedNominees));
  }

  void _onSubmitOpenAnAccount(
    AccountOpeningSubmit event,
    Emitter<AccountOpeningStepsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(state.copyWith(error: 'User not found', isLoading: false));
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final accountResult = await openDepositAccountUseCase.call(
        OpenDepositAccountParams(
          accountType: '',
          accountName: '',
          accountNumber: '',
          accountBalance: '',
          accountCurrency: '',
          accountDescription: '',
          otpRegId: '',
          otpValue: '',
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
        ),
      );

      accountResult.fold(
        (failure) =>
            emit(state.copyWith(error: failure.message, isLoading: false)),
        (message) =>
            emit(state.copyWith(successMessage: message, isLoading: false)),
      );
    } catch (_) {
      emit(
        state.copyWith(error: 'Failed to submit deposit now', isLoading: false),
      );
    }
  }

  Map<String, dynamic> _validateDepositNowSteps(int step) {
    final data = state.stepData[step] ?? {};
    final errors = <String, dynamic>{};

    switch (step) {
      case 0:
        if (state.selectedAccount == null ||
            state.selectedAccount!.number.isEmpty) {
          errors['transferFromAccount'] = 'Select an account to transfer from';
        }
        break;

      case 1:
        // if (data['searchAccountNumber'] == null) {
        //   errors['searchAccountNumber'] =
        //       'Please enter a search account number';
        // }
        // if (data['searchedAccountHolderName'] == null) {
        //   errors['searchedAccountHolderName'] =
        //       'Search account holder name is required';
        // }
        break;

      case 2:
        // final selectedLedgers =
        //     state.nominees.where((l) => l.isSelected).toList();
        // if (selectedLedgers.isEmpty) {
        //   errors['ledgers'] = 'Please select at least one ledger to deposit';
        // } else {
        //   // Map ledgerId to error message for invalid deposit amounts
        //   final Map<String, String> amountErrors = {};

        //   for (final ledger in selectedLedgers) {
        //     if (ledger.depositAmount <= 0) {
        //       amountErrors[ledger.ledgerId.toString()] =
        //           'Deposit amount must be greater than zero';
        //     } else if (!ledger.subledger &&
        //         ledger.depositAmount < ledger.amount) {
        //       amountErrors[ledger.ledgerId.toString()] =
        //           'Deposit amount cannot be less than the ${ledger.amount}';
        //     } else if (ledger.multiplier &&
        //         ledger.depositAmount % ledger.amount != 0) {
        //       amountErrors[ledger.ledgerId.toString()] =
        //           'Deposit amount must be a multiple of ${ledger.amount}';
        //     } else if (ledger.plType == 2 &&
        //         ledger.depositAmount > ledger.loanBalance) {
        //       amountErrors[ledger.ledgerId.toString()] =
        //           'Deposit amount cannot be greater than the ${ledger.loanBalance}';
        //     }
        //   }

        //   if (amountErrors.isNotEmpty) {
        //     errors['amounts'] = amountErrors;
        //   } else {
        //     final totalDeposit = selectedLedgers.fold<double>(
        //       0,
        //       (sum, ledger) => sum + (ledger.depositAmount),
        //     );

        //     final totalWithdrawable =
        //         state.selectedAccount != null
        //             ? state.selectedAccount!.withdrawableBalance
        //             : 0;

        //     if (totalDeposit > totalWithdrawable) {
        //       errors['ledgers'] =
        //           "You don't have enough balance to deposit this amount";
        //     }
        //   }
        // }
        break;

      case 3:
        final nominees = state.nominees;
        if (nominees.isEmpty) {
          errors['nominees'] = 'Please add at least one nominee';
        } else {
          final totalShare = nominees.fold<double>(
            0,
            (sum, nominee) => sum + (nominee.percentage),
          );
          if (totalShare > 100) {
            errors['nominees'] = 'Total nominee share cannot exceed 100%';
          } else if (totalShare < 100) {
            errors['nominees'] = 'Total nominee share must be exactly 100%';
          }
        }
        break;

      case 5:
        if (data['cardPin'] == null || data['cardPin'].toString().isEmpty) {
          errors['cardPin'] = 'Please enter a card PIN';
        } else if (data['cardPin'].length != 4) {
          errors['cardPin'] = 'PIN must be 4 digits';
        }
        break;

      case 6:
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
