import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_instant_loan_usecase.dart';

part 'instant_loan_eligible_event.dart';
part 'instant_loan_eligible_state.dart';

class InstantLoanEligibleBloc
    extends Bloc<InstantLoanEligibleEvent, InstantLoanEligibleState> {
  static const int firstStep = 0;
  static const int lastStep = 4;
  static const int totalSteps = lastStep + 1;

  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitInstantLoansUseCase submitInstantLoansUseCase;

  InstantLoanEligibleBloc({
    required this.getAuthUserUseCase,
    required this.submitInstantLoansUseCase,
  }) : super(const InstantLoanEligibleState(currentStep: 0)) {
    on<InstantLoanGoToNextStep>(_onGoToNextStep);
    on<InstantLoanGoToPreviousStep>(_onGoToPreviousStep);
    on<SelectCardAccount>(_onSelectCardAccount);
    on<SelectDebitCard>(_onSelectDebitCard);
    on<ResetInstantLoanFlow>(_onResetFlow);
    on<UpdateStepData>(_onUpdateStepData);
    on<InstantLoanValidateStep>(_onValidateStep);
    on<SubmitInstantLoan>(_onSubmitInstantLoan);
  }

  void _onValidateStep(
    InstantLoanValidateStep event,
    Emitter<InstantLoanEligibleState> emit,
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
    Emitter<InstantLoanEligibleState> emit,
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
    Emitter<InstantLoanEligibleState> emit,
  ) {
    emit(const InstantLoanEligibleState(currentStep: 0));
  }

  void _onSelectCardAccount(
    SelectCardAccount event,
    Emitter<InstantLoanEligibleState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    SelectDebitCard event,
    Emitter<InstantLoanEligibleState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onGoToNextStep(
    InstantLoanGoToNextStep event,
    Emitter<InstantLoanEligibleState> emit,
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
    InstantLoanEligibleEvent event,
    Emitter<InstantLoanEligibleState> emit,
  ) {
    final current = state.currentStep;
    if (current > firstStep) {
      emit(state.copyWith(currentStep: current - 1));
    }
  }

  void _onSubmitInstantLoan(
    SubmitInstantLoan event,
    Emitter<InstantLoanEligibleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(state.copyWith(error: 'User not found', isLoading: false));
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final cardPinRaw = state.stepData[3]?['cardPin'];
      final otpRegId = state.stepData[3]?['OTPRegId'];
      final otpValue = state.stepData[4]?['OTP'];
      final appliedAmount = state.stepData[1]?['amount'];

      if (cardPinRaw == null ||
          cardPinRaw is! String ||
          cardPinRaw.trim().isEmpty) {
        emit(state.copyWith(error: 'Invalid card PIN', isLoading: false));
        return;
      }

      final cardPin = cardPinRaw.trim();

      final isTopUp = state.stepData[0]?['isTopUp'];

      final secretKey = md5.convert(utf8.encode(cardPin)).toString();

      final accountResult = await submitInstantLoansUseCase.call(
        SubmitInstantLoansProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          nameOnCard: state.selectedCard!.nameOnCard.toLowerCase().trim(),
          secretKey: secretKey,
          otpRegId: otpRegId,
          otpValue: otpValue,
          cardNo: state.selectedCard!.cardNumber,
          accountNo: state.selectedAccount!.number.toString(),
          appliedAmount: appliedAmount,
          isTopUp: isTopUp,
        ),
      );

      accountResult.fold(
        (failure) =>
            emit(state.copyWith(error: failure.message, isLoading: false)),
        (message) =>
            emit(state.copyWith(successMessage: message, isLoading: false)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to submit instant loan',
          isLoading: false,
        ),
      );
    }
  }

  Map<String, dynamic> _validateInstantLoanSteps(int step) {
    final data = state.stepData[step] ?? {};
    final errors = <String, dynamic>{};

    switch (step) {
      case 0:
        break;

      case 1:
        if (data['amount'] == null ||
            data['amount'].toString().trim().isEmpty) {
          errors['amount'] = 'Please enter amount.';
        } else {
          final fieldValue = data['amount'].toString().trim();

          final parsedAmount = double.tryParse(fieldValue);
          final loanAmount = 50000;

          if (parsedAmount == null || parsedAmount <= 0) {
            errors['amount'] = 'Please enter valid amount';
          } else if (parsedAmount <= 10000) {
            if (parsedAmount % 500 != 0) {
              errors['amount'] = 'Amount must be multiplied by 500 /-';
            } else if (parsedAmount > loanAmount) {
              errors['amount'] = 'Amount must be less than $loanAmount /-';
            }
          } else {
            if (parsedAmount % 1000 != 0) {
              errors['amount'] = 'Amount must be multiplied by 1000 /-';
            } else if (parsedAmount > loanAmount) {
              errors['amount'] = 'Amount must be less than $loanAmount /-';
            }
          }
        }

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

      case 5:
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
