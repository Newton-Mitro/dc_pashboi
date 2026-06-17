import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/entities/bkash_payment_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_from_bkash_usecase.dart';
part 'deposit_from_bkash_setps_event.dart';
part 'deposit_from_bkash_steps_state.dart';

class DepositFromBkashStepsBloc
    extends Bloc<DepositFromBkashStepsEvent, DepositFromBkashStepsState> {
  // Define step range constants
  static const int firstStep = 0;
  static const int lastStep = 2;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitDepositFromBkashUseCase submitDepositFromBkashUseCase;
  final AppLocalizationService appLocalizationService;

  DepositFromBkashStepsBloc({
    required this.getAuthUserUseCase,
    required this.submitDepositFromBkashUseCase,
    required this.appLocalizationService,
  }) : super(const DepositFromBkashStepsState(currentStep: 0)) {
    on<DepositFromBkashGoToNextStep>(_onGoToNextStep);
    on<DepositFromBkashGoToPreviousStep>(_onGoToPreviousStep);
    on<DepositFromBkashUpdateStepData>(_onUpdateStepData);
    on<DepositFromBkashSetCollectionLedgers>(_onSetCollectionLedgers);
    on<DepositFromBkashToggleLedgerSelection>(_onToggleLedgerSelection);
    on<DepositFromBkashToggleSelectAllLedgers>(_onToggleSelectAllLedgers);
    on<DepositFromBkashUpdateLedgerAmount>(_onUpdateLedgerAmount);
    on<DepositFromBkashResetFlow>(_onResetFlow);
    on<DepositFromBkashUpdateLpsAmount>(_onUpdateLpsAmount);
    on<DepositFromBkashValidateStep>(_onValidateStep);
    on<DepositFromBkashSubmit>(_onSubmitDepositNow);
  }

  void _onGoToNextStep(
    DepositFromBkashGoToNextStep event,
    Emitter<DepositFromBkashStepsState> emit,
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
    DepositFromBkashGoToPreviousStep event,
    Emitter<DepositFromBkashStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    DepositFromBkashUpdateStepData event,
    Emitter<DepositFromBkashStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onSetCollectionLedgers(
    DepositFromBkashSetCollectionLedgers event,
    Emitter<DepositFromBkashStepsState> emit,
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
    DepositFromBkashToggleLedgerSelection event,
    Emitter<DepositFromBkashStepsState> emit,
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
    DepositFromBkashToggleSelectAllLedgers event,
    Emitter<DepositFromBkashStepsState> emit,
  ) {
    final updatedLedgers =
        state.collectionLedgers
            .map((l) => l.copyWith(isSelected: event.selectAll))
            .toList();

    emit(state.copyWith(collectionLedgers: updatedLedgers));
  }

  void _onUpdateLedgerAmount(
    DepositFromBkashUpdateLedgerAmount event,
    Emitter<DepositFromBkashStepsState> emit,
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
    DepositFromBkashResetFlow event,
    Emitter<DepositFromBkashStepsState> emit,
  ) {
    emit(const DepositFromBkashStepsState(currentStep: 0));
  }

  void _onUpdateLpsAmount(
    DepositFromBkashUpdateLpsAmount event,
    Emitter<DepositFromBkashStepsState> emit,
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
    DepositFromBkashValidateStep event,
    Emitter<DepositFromBkashStepsState> emit,
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
    DepositFromBkashSubmit event,
    Emitter<DepositFromBkashStepsState> emit,
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

      final selectedLedgers =
          state.collectionLedgers.where((l) => l.isSelected).toList();

      final totalAmount = selectedLedgers.fold<double>(
        0.0,
        (sum, ledger) => sum + ledger.depositAmount,
      );

      final accountResult = await submitDepositFromBkashUseCase.call(
        SubmitDepositFromBkashProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          totalDepositAmount: totalAmount,
          transactionMethod: '11',
          transactionType: 'bKashDepositRequest',
          collectionLedgers: selectedLedgers,
        ),
      );

      accountResult.fold(
        (failure) =>
            emit(state.copyWith(error: failure.message, isLoading: false)),
        (message) =>
            emit(state.copyWith(bkashPaymentEntity: message, isLoading: false)),
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
        if (data['searchAccountNumber'] == null) {
          errors['searchAccountNumber'] = appLocalizationService.t(
            'please_enter_account_number',
          );
        }
        if (data['searchedAccountHolderName'] == null) {
          errors['searchedAccountHolderName'] = appLocalizationService.t(
            'account_holder_name_is_required',
          );
        }
        break;

      case 1:
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

      default:
        break;
    }

    return errors;
  }
}
