import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/entities/dc_bank_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_bank_to_dc_usecase.dart';
part 'bank_to_dc_transfer_setps_event.dart';
part 'bank_to_dc_transfer_steps_state.dart';

class BankToDcTransferStepsBloc
    extends Bloc<BankToDcTransferStepsEvent, BankToDcTransferStepsState> {
  // Define step range constants
  static const int firstStep = 0;
  static const int lastStep = 5;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitTransferBankToDcUseCase submitTransferBankToDcUseCase;
  final AppLocalizationService appLocalizationService;

  BankToDcTransferStepsBloc({
    required this.getAuthUserUseCase,
    required this.submitTransferBankToDcUseCase,
    required this.appLocalizationService,
  }) : super(
         BankToDcTransferStepsState(
           currentStep: 0,
           selectedAccount: null,
           selectedBankAccount: DcBankEntity.empty(),
           selectedCard: null,
           validationErrors: {},
           stepData: {},
           collectionLedgers: [],
           isLoading: false,
           error: null,
           successMessage: null,
         ),
       ) {
    on<BankToDcTransferGoToNextStep>(_onGoToNextStep);
    on<BankToDcTransferGoToPreviousStep>(_onGoToPreviousStep);
    on<BankToDcTransferUpdateStepData>(_onUpdateStepData);
    on<BankToDcTransferSetCollectionLedgers>(_onSetCollectionLedgers);
    on<BankToDcTransferSelectBankAccount>(_onSelectBankAccount);
    on<BankToDcTransferSelectCardAccount>(_onSelectCardAccount);
    on<BankToDcTransferSelectDebitCard>(_onSelectDebitCard);
    on<BankToDcTransferValidateStep>(_onValidateStep);
    on<BankToDcTransferSubmit>(_onSubmitDepositNow);
  }

  void _onGoToNextStep(
    BankToDcTransferGoToNextStep event,
    Emitter<BankToDcTransferStepsState> emit,
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
    BankToDcTransferGoToPreviousStep event,
    Emitter<BankToDcTransferStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    BankToDcTransferUpdateStepData event,
    Emitter<BankToDcTransferStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onSelectBankAccount(
    BankToDcTransferSelectBankAccount event,
    Emitter<BankToDcTransferStepsState> emit,
  ) {
    emit(state.copyWith(selectedBankAccount: event.selectedBankAccount));
  }

  void _onSelectCardAccount(
    BankToDcTransferSelectCardAccount event,
    Emitter<BankToDcTransferStepsState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    BankToDcTransferSelectDebitCard event,
    Emitter<BankToDcTransferStepsState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onValidateStep(
    BankToDcTransferValidateStep event,
    Emitter<BankToDcTransferStepsState> emit,
  ) {
    final step = event.step;

    final errors = _validateDepositNowSteps(step);
    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );

    updatedValidationErrors[step] = errors;

    emit(state.copyWith(validationErrors: updatedValidationErrors));
  }

  Future<String> fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  void _onSubmitDepositNow(
    BankToDcTransferSubmit event,
    Emitter<BankToDcTransferStepsState> emit,
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

      final file = state.stepData[1]?['receiptFile'];

      String? base64String;
      if (file != null && file is File) {
        base64String = await fileToBase64(file);
      } else {
        base64String = '';
      }

      final accountResult = await submitTransferBankToDcUseCase.call(
        SubmitTransferBankToDcProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,

          accountNumber: state.selectedAccount!.number, // Saving Account
          accountHolderName:
              state.selectedCard!.nameOnCard.toLowerCase().trim(),
          accountId: state.selectedAccount!.id,
          ledgerId: state.selectedAccount!.ledgerId,

          cardNumber: state.selectedCard!.cardNumber,
          nameOnCard: state.selectedCard!.nameOnCard,
          cardPin:
              md5
                  .convert(utf8.encode(state.stepData[4]?['cardPin'].trim()))
                  .toString(),

          toBankAccountNumber: state.selectedBankAccount.bankAccNumber,
          bankRoutingNumber: state.selectedBankAccount.bankRoutingNo,

          transactionReceipt: base64String,
          transactionNumber: '',
          depositDate: DateTime.now().toIso8601String(),
          totalDepositAmount:
              state.stepData[1]?['amount'] != null
                  ? double.parse(state.stepData[1]?['amount'])
                  : 0.0,

          otpRegId: state.stepData[4]?['OTPRegId'],
          otpValue: state.stepData[5]?['OTP'],

          collectionLedgers: state.collectionLedgers,
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

  void _onSetCollectionLedgers(
    BankToDcTransferSetCollectionLedgers event,
    Emitter<BankToDcTransferStepsState> emit,
  ) {
    final selectedLedgers = [event.ledger];
    emit(state.copyWith(collectionLedgers: selectedLedgers));
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
        if (data['amount'] == null) {
          errors['amount'] = appLocalizationService.t(
            'please_enter_deposit_amount',
          );
        }
        if (state.selectedBankAccount.bankAccNumber.isEmpty) {
          errors['bank'] = appLocalizationService.t(
            'please_select_a_bank_account',
          );
        }
        if (data['receiptFile'] == null) {
          errors['receiptFile'] = appLocalizationService.t(
            'please_attach_a_transaction_receipt',
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
          final Map<String, String> amountErrors = {};

          for (final ledger in selectedLedgers) {
            if (ledger.depositAmount <= 0) {
              amountErrors[ledger.ledgerId.toString()] = appLocalizationService
                  .t('deposit_amount_must_be_greater_than_zero');
            } else if (!ledger.subledger &&
                ledger.depositAmount < ledger.amount) {
              amountErrors[ledger.ledgerId.toString()] =
                  appLocalizationService.t(
                    'deposit_amunt_cannot_be_less_than_the',
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

      case 4:
        if (data['cardPin'] == null || data['cardPin'].toString().isEmpty) {
          errors['cardPin'] = appLocalizationService.t(
            'please_enter_a_card_pin',
          );
        } else if (data['cardPin'].length != 4) {
          errors['cardPin'] = appLocalizationService.t('pin_must_be_4_digits');
        }
        break;

      case 5:
        if (data['confirmation'] != true) {
          errors['confirmation'] = appLocalizationService.t(
            'you_must_confirm_to_proceed',
          );
        }
        break;

      default:
        break;
    }

    return errors;
  }
}
