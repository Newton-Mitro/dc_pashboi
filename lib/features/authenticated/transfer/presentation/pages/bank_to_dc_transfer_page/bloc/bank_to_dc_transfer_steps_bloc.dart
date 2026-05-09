import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
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

  BankToDcTransferStepsBloc({
    required this.getAuthUserUseCase,
    required this.submitTransferBankToDcUseCase,
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
        emit(state.copyWith(error: 'User not found', isLoading: false));
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
          accountNumber: state.selectedAccount!.number,
          accountHolderName:
              state.selectedCard!.nameOnCard.toLowerCase().trim(),
          accountId: state.selectedAccount!.id,
          cardNumber: state.selectedCard!.cardNumber,
          depositDate: DateTime.now().toIso8601String(),
          ledgerId: state.selectedAccount!.ledgerId,
          cardPin:
              md5
                  .convert(utf8.encode(state.stepData[4]?['cardPin'].trim()))
                  .toString(),
          totalDepositAmount:
              state.stepData[1]?['amount'] != null
                  ? double.parse(state.stepData[1]?['amount'])
                  : 0.0,
          otpRegId: state.stepData[4]?['OTPRegId'],
          otpValue: state.stepData[5]?['OTP'],
          collectionLedgers: state.collectionLedgers,
          bankRoutingNumber: state.selectedBankAccount.bankRoutingNo,
          transactionReceipt: base64String,
          transactionNumber: '',
          toBankAccountNumber: state.selectedBankAccount.bankAccNumber,
          nameOnCard: state.selectedCard!.nameOnCard,
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
          errors['transferFromAccount'] = 'Select an account to transfer from';
        }
        break;

      case 1:
        if (data['amount'] == null) {
          errors['amount'] = 'Please enter deposit amount';
        }
        if (state.selectedBankAccount.bankAccNumber.isEmpty) {
          errors['bank'] = 'Please select a bank account';
        }
        if (data['receiptFile'] == null) {
          errors['receiptFile'] = 'Please attach a transaction receipt';
        }
        break;

      case 2:
        final selectedLedgers =
            state.collectionLedgers.where((l) => l.isSelected).toList();
        if (selectedLedgers.isEmpty) {
          errors['ledgers'] = 'Please select at least one ledger to deposit';
        } else {
          final Map<String, String> amountErrors = {};

          for (final ledger in selectedLedgers) {
            if (ledger.depositAmount <= 0) {
              amountErrors[ledger.ledgerId.toString()] =
                  'Deposit amount must be greater than zero';
            } else if (!ledger.subledger &&
                ledger.depositAmount < ledger.amount) {
              amountErrors[ledger.ledgerId.toString()] =
                  'Deposit amount cannot be less than the ${ledger.amount}';
            } else if (ledger.multiplier &&
                ledger.depositAmount % ledger.amount != 0) {
              amountErrors[ledger.ledgerId.toString()] =
                  'Deposit amount must be a multiple of ${ledger.amount}';
            } else if (ledger.plType == 2 &&
                ledger.depositAmount > ledger.loanBalance) {
              amountErrors[ledger.ledgerId.toString()] =
                  'Deposit amount cannot be greater than the ${ledger.loanBalance}';
            }
          }

          if (amountErrors.isNotEmpty) {
            errors['amounts'] = amountErrors;
          }
        }
        break;

      case 4:
        if (data['cardPin'] == null || data['cardPin'].toString().isEmpty) {
          errors['cardPin'] = 'Please enter a card PIN';
        } else if (data['cardPin'].length != 4) {
          errors['cardPin'] = 'PIN must be 4 digits';
        }
        break;

      case 5:
        if (data['confirmation'] != true) {
          errors['confirmation'] = 'You must confirm to proceed';
        }
        break;

      default:
        break;
    }

    return errors;
  }
}
