import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';
part 'internal_transfer_setps_event.dart';
part 'internal_transfer_steps_state.dart';

class InternalTransferStepsBloc
    extends Bloc<InternalTransferStepsEvent, InternalTransferStepsState> {
  static const int firstStep = 0;
  static const int lastStep = 5;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitFundTransferUseCase submitFundTransferUseCase;

  InternalTransferStepsBloc({
    required this.getAuthUserUseCase,
    required this.submitFundTransferUseCase,
  }) : super(const InternalTransferStepsState(currentStep: 0)) {
    on<InternalTransferGoToNextStep>(_onGoToNextStep);
    on<InternalTransferGoToPreviousStep>(_onGoToPreviousStep);
    on<InternalTransferUpdateStepData>(_onUpdateStepData);
    on<InternalTransferSelectCardAccount>(_onSelectCardAccount);
    on<InternalTransferSelectDebitCard>(_onSelectDebitCard);
    on<InternalTransferValidateStep>(_onValidateStep);
    on<InternalTransferSubmit>(_onSubmitFundTransfer);
  }

  void _onGoToNextStep(
    InternalTransferGoToNextStep event,
    Emitter<InternalTransferStepsState> emit,
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
    InternalTransferGoToPreviousStep event,
    Emitter<InternalTransferStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    InternalTransferUpdateStepData event,
    Emitter<InternalTransferStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onSelectCardAccount(
    InternalTransferSelectCardAccount event,
    Emitter<InternalTransferStepsState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    InternalTransferSelectDebitCard event,
    Emitter<InternalTransferStepsState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onValidateStep(
    InternalTransferValidateStep event,
    Emitter<InternalTransferStepsState> emit,
  ) {
    final step = event.step;

    final errors = _validateDepositNowSteps(step);
    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );

    updatedValidationErrors[step] = errors;

    emit(state.copyWith(validationErrors: updatedValidationErrors));
  }

  void _onSubmitFundTransfer(
    InternalTransferSubmit event,
    Emitter<InternalTransferStepsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(state.copyWith(error: 'User not found', isLoading: false));
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final accountResult = await submitFundTransferUseCase.call(
        SubmitFundTransferProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          accountNumber: state.selectedAccount!.number,
          accountType: state.selectedAccount!.typeName,
          cardNumber: state.selectedCard!.cardNumber,
          cardPin:
              md5
                  .convert(utf8.encode(state.stepData[4]?['cardPin'].trim()))
                  .toString(),
          otpRegId: state.stepData[4]?['OTPRegId'],
          otpValue: state.stepData[5]?['OTP'],
          amount: event.transferAmount,
          toAccountNumber: event.toAccountNumber,
          nameOnCard: state.selectedCard!.nameOnCard.toLowerCase().trim(),
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
        if (data['searchAccountNumber'] == null) {
          errors['searchAccountNumber'] =
              'Please enter a search account number';
        }
        if (data['searchedAccountHolderName'] == null) {
          errors['searchedAccountHolderName'] =
              'Search account holder name is required';
        }
        break;

      // case 1:
      //   final searchAcc = data['searchAccountNumber'];
      //   final ownAcc = state.selectedAccount?.number;

      //   if (searchAcc == null) {
      //     errors['searchAccountNumber'] =
      //         'Please enter a search account number';
      //   } else {
      //     final formattedSearch = getFormattedAccountNumber(searchAcc);
      //     final formattedOwn = getFormattedAccountNumber(ownAcc);

      //     if (formattedSearch == formattedOwn) {
      //       errors['searchAccountNumber'] =
      //           "You can't transfer to your own account.";
      //     }
      //   }

      case 2:
        if (data['transferAmount'] == '' || data['transferAmount'] == null) {
          errors['transferAmount'] = 'Please enter transfer amount';
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
