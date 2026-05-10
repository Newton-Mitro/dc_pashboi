import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/usecases/generate_withdrawl_qr_usecase.dart';
part 'withdrawl_qr_setps_event.dart';
part 'withdrawl_qr_steps_state.dart';

class WithdrawlQrStepsBloc
    extends Bloc<WithdrawlQrStepsEvent, WithdrawlQrStepsState> {
  // Define step range constants
  static const int firstStep = 0;
  static const int lastStep = 3;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final GenerateWithdrawlQrUseCase generateWithdrawlQrUseCase;
  final AppLocalizationService appLocalizationService;

  WithdrawlQrStepsBloc({
    required this.getAuthUserUseCase,
    required this.generateWithdrawlQrUseCase,
    required this.appLocalizationService,
  }) : super(const WithdrawlQrStepsState(currentStep: 0)) {
    on<WithdrawlQrGoToNextStep>(_onGoToNextStep);
    on<WithdrawlQrGoToPreviousStep>(_onGoToPreviousStep);
    on<WithdrawlQrUpdateStepData>(_onUpdateStepData);

    on<WithdrawlQrSelectCardAccount>(_onSelectCardAccount);
    on<WithdrawlQrSelectDebitCard>(_onSelectDebitCard);
    // update lps amount

    on<WithdrawlQrValidateStep>(_onValidateStep);
    on<WithdrawlQrSubmit>(_onSubmitWithdrawlQr);
  }

  void _onGoToNextStep(
    WithdrawlQrGoToNextStep event,
    Emitter<WithdrawlQrStepsState> emit,
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
    WithdrawlQrGoToPreviousStep event,
    Emitter<WithdrawlQrStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    WithdrawlQrUpdateStepData event,
    Emitter<WithdrawlQrStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onSelectCardAccount(
    WithdrawlQrSelectCardAccount event,
    Emitter<WithdrawlQrStepsState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    WithdrawlQrSelectDebitCard event,
    Emitter<WithdrawlQrStepsState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onValidateStep(
    WithdrawlQrValidateStep event,
    Emitter<WithdrawlQrStepsState> emit,
  ) {
    final step = event.step;

    final errors = _validateDepositNowSteps(step);
    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );

    updatedValidationErrors[step] = errors;

    emit(state.copyWith(validationErrors: updatedValidationErrors));
  }

  void _onSubmitWithdrawlQr(
    WithdrawlQrSubmit event,
    Emitter<WithdrawlQrStepsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(state.copyWith(error: 'User not found', isLoading: false));
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final accountResult = await generateWithdrawlQrUseCase.call(
        GenerateWithdrawlQrProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          accountNumber: state.selectedAccount!.number,
          cardNumber: state.selectedCard!.cardNumber,
          cardPin:
              md5
                  .convert(utf8.encode(state.stepData[2]?['cardPin']?.trim()))
                  .toString(),
          otpRegId: state.stepData[2]?['OTPRegId'],
          otpValue: state.stepData[3]?['OTP'],
          amount: event.withdrawAmount,
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
      emit(state.copyWith(error: 'Failed to generate QR', isLoading: false));
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
        final withdrawAmount = int.tryParse(
          data['withdrawAmount']?.toString() ?? '',
        );
        final totalWithdrawable =
            state.selectedAccount != null
                ? state.selectedAccount!.withdrawableBalance
                : 0;

        if (withdrawAmount == null) {
          errors['withdrawAmount'] = 'Enter withdraw amount';
        } else if (withdrawAmount < 500) {
          errors['withdrawAmount'] = 'Minimum withdraw amount is 500';
        } else if (withdrawAmount % 500 != 0) {
          errors['withdrawAmount'] = 'Amount must be a multiple of 500';
        } else if (withdrawAmount > totalWithdrawable) {
          errors['withdrawAmount'] = 'Amount exceeds withdrawable balance';
        }
        break;

      case 2:
        if (data['cardPin'] == null || data['cardPin'].toString().isEmpty) {
          errors['cardPin'] = 'Please enter a card PIN';
        } else if (data['cardPin'].length != 4) {
          errors['cardPin'] = 'PIN must be 4 digits';
        }
        break;

      case 3:
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
