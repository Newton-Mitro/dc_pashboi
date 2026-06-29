import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_transfer_to_bkash_usecase.dart';
part 'transfer_to_bkash_setps_event.dart';
part 'transfer_to_bkash_steps_state.dart';

class TransferToBkashStepsBloc
    extends Bloc<TransferToBkashStepsEvent, TransferToBkashStepsState> {
  // Define step range constants
  static const int firstStep = 0;
  static const int lastStep = 5;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitTransferToBkashUseCase submitTransferToBkashUseCase;
  final AppLocalizationService appLocalizationService;

  TransferToBkashStepsBloc({
    required this.getAuthUserUseCase,
    required this.submitTransferToBkashUseCase,
    required this.appLocalizationService,
  }) : super(const TransferToBkashStepsState(currentStep: 0)) {
    on<TransferToBkashGoToNextStep>(_onGoToNextStep);
    on<TransferToBkashGoToPreviousStep>(_onGoToPreviousStep);
    on<TransferToBkashUpdateStepData>(_onUpdateStepData);
    on<TransferToBkashSelectCardAccount>(_onSelectCardAccount);
    on<TransferToBkashSelectDebitCard>(_onSelectDebitCard);
    on<TransferToBkashValidateStep>(_onValidateStep);
    on<TransferToBkashSubmit>(_onSubmitTransferToBkash);
    on<TransferToBkashLoadUser>(_onLoadUser);

    add(TransferToBkashLoadUser());
  }

  void _onLoadUser(
    TransferToBkashLoadUser event,
    Emitter<TransferToBkashStepsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final authUserResult = await getAuthUserUseCase.call(NoParams());

    authUserResult.fold(
      (failure) {
        emit(state.copyWith(error: failure.message, isLoading: false));
      },
      (authUserEntity) {
        final updatedStepData = Map<int, Map<String, dynamic>>.from(
          state.stepData,
        );
        updatedStepData[1] = {
          ...?updatedStepData[1],
          ...{
            'transferToMobile': authUserEntity.user.regMobile
                .replaceAll('+880', '')
                .replaceAll('-', ''),
          },
        };
        emit(state.copyWith(stepData: updatedStepData, isLoading: false));
      },
    );
  }

  void _onGoToNextStep(
    TransferToBkashGoToNextStep event,
    Emitter<TransferToBkashStepsState> emit,
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
    TransferToBkashGoToPreviousStep event,
    Emitter<TransferToBkashStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    TransferToBkashUpdateStepData event,
    Emitter<TransferToBkashStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onSelectCardAccount(
    TransferToBkashSelectCardAccount event,
    Emitter<TransferToBkashStepsState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    TransferToBkashSelectDebitCard event,
    Emitter<TransferToBkashStepsState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onValidateStep(
    TransferToBkashValidateStep event,
    Emitter<TransferToBkashStepsState> emit,
  ) {
    final step = event.step;

    final errors = _validateDepositNowSteps(step);
    final updatedValidationErrors = Map<int, Map<String, dynamic>>.from(
      state.validationErrors,
    );

    updatedValidationErrors[step] = errors;

    emit(state.copyWith(validationErrors: updatedValidationErrors));
  }

  void _onSubmitTransferToBkash(
    TransferToBkashSubmit event,
    Emitter<TransferToBkashStepsState> emit,
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

      final accountResult = await submitTransferToBkashUseCase.call(
        SubmitTransferToBkashProps(
          transferToAcc: user.regMobile,
          recipientName: user.userName,
          accountHolderName: user.userName,
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
          amount: double.tryParse(state.stepData[2]?['transferAmount']) ?? 0.0,
          toBkashNumber: "+880-${state.stepData[1]?['transferToMobile']}",
          nameOnCard: state.selectedCard!.nameOnCard,
          ledgerId: state.selectedCard!.cardsAccounts[0].ledgerId,
          accountId: state.selectedCard!.cardsAccounts[0].id,
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
        if (data['transferToMobile'] == null ||
            data['transferToMobile'].isEmpty) {
          errors['transferToMobile'] = appLocalizationService.t(
            'please_enter_transfer_to_mobile_number',
          );
        }

        break;

      case 2:
        if (data['transferAmount'] == null) {
          errors['transferAmount'] = appLocalizationService.t(
            'please_enter_transfer_amount',
          );
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

      // No validation needed for final review/step 5
      default:
        break;
    }

    return errors;
  }
}
