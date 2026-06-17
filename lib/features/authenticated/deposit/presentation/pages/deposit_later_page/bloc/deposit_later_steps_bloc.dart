import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_later_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
part 'deposit_later_setps_event.dart';
part 'deposit_later_steps_state.dart';

class DepositLaterStepsBloc
    extends Bloc<DepositLaterStepsEvent, DepositLaterStepsState> {
  // Define step range constants
  static const int firstStep = 0;
  static const int lastStep = 6;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitDepositLaterUseCase submitDepositLaterUseCase;
  final AppLocalizationService appLocalizationService;

  DepositLaterStepsBloc({
    required this.getAuthUserUseCase,
    required this.submitDepositLaterUseCase,
    required this.appLocalizationService,
  }) : super(const DepositLaterStepsState(currentStep: 0)) {
    on<DepositLaterGoToNextStep>(_onGoToNextStep);
    on<DepositLaterGoToPreviousStep>(_onGoToPreviousStep);
    on<DepositLaterUpdateStepData>(_onUpdateStepData);
    on<DepositLaterSetCollectionLedgers>(_onSetCollectionLedgers);
    on<DepoistLaterToggleLedgerSelection>(_onToggleLedgerSelection);
    on<DepositLaterToggleSelectAllLedgers>(_onToggleSelectAllLedgers);
    on<DepositLaterUpdateLedgerAmount>(_onUpdateLedgerAmount);
    on<DepositLaterFlowReset>(_onResetFlow);
    on<DepositLaterSelectCardAccount>(_onSelectCardAccount);
    on<DepositLaterSelectDebitCard>(_onSelectDebitCard);
    // update lps amount
    on<DepositLaterUpdateLpsAmount>(_onUpdateLpsAmount);
    on<DepositLaterValidateStep>(_onValidateStep);
    on<DepositLaterSubmit>(_onSubmitDepositNow);
  }

  void _onGoToNextStep(
    DepositLaterGoToNextStep event,
    Emitter<DepositLaterStepsState> emit,
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
    DepositLaterGoToPreviousStep event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    DepositLaterUpdateStepData event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onSetCollectionLedgers(
    DepositLaterSetCollectionLedgers event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    final selectedLedgers =
        event.ledgers
            .map(
              (ledger) => ledger.copyWith(
                depositAmount: ledger.amount,
                isSelected: false,
              ),
            )
            .toList();
    emit(state.copyWith(collectionLedgers: selectedLedgers));
  }

  void _onToggleLedgerSelection(
    DepoistLaterToggleLedgerSelection event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    late List<CollectionLedgerEntity> updatedLedgers;

    if (event.ledger.subledger) {
      updatedLedgers =
          state.collectionLedgers.map((l) {
            if (l.accountNumber == event.ledger.accountNumber) {
              return l.copyWith(isSelected: !(event.ledger.isSelected));
            }
            return l;
          }).toList();
    } else if (event.ledger.plType == 2 || event.ledger.plType == 1) {
      updatedLedgers =
          state.collectionLedgers.map((l) {
            if (l.accountNumber == event.ledger.accountNumber &&
                !event.ledger.isSelected) {
              return l.copyWith(isSelected: true);
            } else if (l.accountNumber == event.ledger.accountNumber &&
                event.ledger.ledgerId == l.ledgerId) {
              return l.copyWith(isSelected: false);
            }
            return l;
          }).toList();
    } else {
      updatedLedgers =
          state.collectionLedgers.map((l) {
            if (l.accountId == event.ledger.accountId &&
                l.accountNumber == event.ledger.accountNumber &&
                l.ledgerId == event.ledger.ledgerId) {
              return l.copyWith(isSelected: !(l.isSelected));
            }
            return l;
          }).toList();
    }

    emit(state.copyWith(collectionLedgers: updatedLedgers));
  }

  void _onToggleSelectAllLedgers(
    DepositLaterToggleSelectAllLedgers event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    final updatedLedgers =
        state.collectionLedgers
            .map((l) => l.copyWith(isSelected: event.selectAll))
            .toList();

    emit(state.copyWith(collectionLedgers: updatedLedgers));
  }

  void _onUpdateLedgerAmount(
    DepositLaterUpdateLedgerAmount event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    if (!event.ledger.subledger &&
        event.ledger.plType == 2 &&
        event.ledger.lps) {
      return;
    }
    final updatedLedgers =
        state.collectionLedgers.map((l) {
          if (l.accountId == event.ledger.accountId &&
              l.accountNumber == event.ledger.accountNumber &&
              l.ledgerId == event.ledger.ledgerId) {
            return l.copyWith(depositAmount: event.newAmount);
          }
          return l;
        }).toList();

    emit(state.copyWith(collectionLedgers: updatedLedgers));
  }

  void _onResetFlow(
    DepositLaterFlowReset event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    emit(const DepositLaterStepsState(currentStep: 0));
  }

  void _onSelectCardAccount(
    DepositLaterSelectCardAccount event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    DepositLaterSelectDebitCard event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onUpdateLpsAmount(
    DepositLaterUpdateLpsAmount event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    final updatedLedgers =
        state.collectionLedgers.map((l) {
          if (l.collectionType.trim() == 'LoanLpsAmount' &&
              l.accountNumber == event.loanNumber) {
            return l.copyWith(depositAmount: event.newAmount);
          }
          return l;
        }).toList();

    emit(state.copyWith(collectionLedgers: updatedLedgers));
  }

  void _onValidateStep(
    DepositLaterValidateStep event,
    Emitter<DepositLaterStepsState> emit,
  ) {
    final step = event.step;

    final errors = _validateDepositNowSteps(step);
    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );

    updatedValidationErrors[step] = errors;

    emit(state.copyWith(validationErrors: updatedValidationErrors));
  }

  void _onSubmitDepositNow(
    DepositLaterSubmit event,
    Emitter<DepositLaterStepsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(
          state.copyWith(
            error: appLocalizationService.t('failed_to_load_user_info'),
            isLoading: false,
          ),
        );
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final totalAmount = state.collectionLedgers
          .where((ledger) => ledger.isSelected)
          .fold<double>(0.0, (sum, ledger) => sum + ledger.depositAmount);

      final accountResult = await submitDepositLaterUseCase.call(
        SubmitDepositLaterProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          accountNumber: state.selectedAccount!.number,
          accountHolderName:
              state.selectedCard!.nameOnCard.toLowerCase().trim(),
          accountId: state.selectedAccount!.id,
          accountType: state.selectedAccount!.typeName,
          cardNumber: state.selectedCard!.cardNumber,
          depositDate: DateTime.now().toIso8601String(),
          ledgerId: state.selectedAccount!.ledgerId,
          cardPin:
              md5
                  .convert(utf8.encode(state.stepData[5]?['cardPin'].trim()))
                  .toString(),
          totalDepositAmount: totalAmount,
          otpRegId: state.stepData[5]?['OTPRegId'],
          otpValue: state.stepData[6]?['OTP'],
          collectionLedgers: state.collectionLedgers,
          repeatMonths: state.stepData[3]?['numberOfMonth'],
          dayOfMonth: int.parse(
            state.stepData[3]?['monthlyDepositDate'] ?? '0',
          ),
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
        state.copyWith(
          error: appLocalizationService.t('failed_to_submit_deposit_now'),
          isLoading: false,
        ),
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
          errors['transferFromAccount'] = appLocalizationService.t(
            'select_an_account_to_transfer_from',
          );
        }
        break;

      case 1:
        if (data['searchAccountNumber'] == null) {
          errors['searchAccountNumber'] = appLocalizationService.t(
            'please_enter_a_search_account_number',
          );
        }
        if (data['searchedAccountHolderName'] == null) {
          errors['searchedAccountHolderName'] = appLocalizationService.t(
            'account_holder_name_is_required',
          );
        }
        break;

      case 2:
        final selectedLedgers =
            state.collectionLedgers.where((l) => l.isSelected).toList();
        if (selectedLedgers.isEmpty) {
          errors['ledgers'] = appLocalizationService.t(
            'please_select_at_least_one_account',
          );
        } else {
          // Map ledgerId to error message for invalid deposit amounts
          final Map<String, String> amountErrors = {};

          for (final ledger in selectedLedgers) {
            if (ledger.depositAmount <= 0) {
              amountErrors[ledger.ledgerId.toString()] = appLocalizationService
                  .t('deposit_amount_must_be_greater_than_zero');
            } else if (!ledger.subledger &&
                ledger.depositAmount < ledger.amount) {
              amountErrors[ledger.ledgerId.toString()] =
                  appLocalizationService.t(
                    'deposit_amount_cannot_be_less_than',
                  ) +
                  ledger.amount.toString();
            } else if (ledger.multiplier &&
                ledger.depositAmount % ledger.amount != 0) {
              amountErrors[ledger.ledgerId.toString()] =
                  appLocalizationService.t(
                    'deposit_amount_must_be_a_multiple_of',
                  ) +
                  ledger.amount.toString();
            } else if (ledger.plType == 2 &&
                ledger.depositAmount > ledger.loanBalance) {
              amountErrors[ledger.ledgerId.toString()] =
                  appLocalizationService.t(
                    'deposit_amount_cannot_be_greater_than',
                  ) +
                  ledger.loanBalance.toString();
            }
          }

          if (amountErrors.isNotEmpty) {
            errors['amounts'] = amountErrors;
          }
        }
        break;

      case 3:
        if (data['monthlyDepositDate'] == null) {
          errors['monthlyDepositDate'] = appLocalizationService.t(
            'please_select_monthly_deposit_date',
          );
        }
        if (data['numberOfMonth'] == null) {
          errors['numberOfMonth'] = appLocalizationService.t(
            'please_select_number_of_months_to_deposit',
          );
        }
        break;

      case 5:
        if (data['cardPin'] == null || data['cardPin'].toString().isEmpty) {
          errors['cardPin'] = appLocalizationService.t(
            'please_enter_a_card_pin',
          );
        } else if (data['cardPin'].length != 4) {
          errors['cardPin'] = appLocalizationService.t('pin_must_be_4_digits');
        }
        break;

      case 6:
        if (data['confirmation'] != true) {
          errors['confirmation'] = appLocalizationService.t(
            'you_must_confirm_to_proceed',
          );
        }
        break;

      // No validation needed for final review/step 5
      default:
        break;
    }

    return errors;
  }
}
