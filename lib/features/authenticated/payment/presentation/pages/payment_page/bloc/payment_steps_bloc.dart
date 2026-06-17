import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/payment/domain/entities/notify_person_entity.dart';
import 'package:pashboi/features/authenticated/payment/domain/entities/service_entity.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/submit_payment_usecase.dart';
part 'payment_setps_event.dart';
part 'payment_steps_state.dart';

class PaymentStepsBloc extends Bloc<PaymentStepsEvent, PaymentStepsState> {
  // Define step range constants
  static const int firstStep = 0;
  static const int lastStep = 5;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitPaymentUseCase submitPaymentUseCase;
  final AppLocalizationService appLocalizationService;

  PaymentStepsBloc({
    required this.getAuthUserUseCase,
    required this.submitPaymentUseCase,
    required this.appLocalizationService,
  }) : super(const PaymentStepsState(currentStep: 0)) {
    on<PaymentGoToNextStep>(_onGoToNextStep);
    on<PaymentGoToPreviousStep>(_onGoToPreviousStep);
    on<PaymentUpdateStepData>(_onUpdateStepData);
    on<PaymentSelectCardAccount>(_onSelectCardAccount);
    on<PaymentSelectDebitCard>(_onSelectDebitCard);
    on<PaymentValidateStep>(_onValidateStep);
    on<PaymentSubmit>(_onSubmitDepositNow);
  }

  void _onGoToNextStep(
    PaymentGoToNextStep event,
    Emitter<PaymentStepsState> emit,
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
    PaymentGoToPreviousStep event,
    Emitter<PaymentStepsState> emit,
  ) {
    if (state.currentStep > firstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateStepData(
    PaymentUpdateStepData event,
    Emitter<PaymentStepsState> emit,
  ) {
    final updatedStepData = Map<int, Map<String, dynamic>>.from(state.stepData);
    updatedStepData[event.step] = {
      ...?updatedStepData[event.step],
      ...event.data,
    };
    emit(state.copyWith(stepData: updatedStepData));
  }

  void _onSelectCardAccount(
    PaymentSelectCardAccount event,
    Emitter<PaymentStepsState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    PaymentSelectDebitCard event,
    Emitter<PaymentStepsState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onValidateStep(
    PaymentValidateStep event,
    Emitter<PaymentStepsState> emit,
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
    PaymentSubmit event,
    Emitter<PaymentStepsState> emit,
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

      final accountResult = await submitPaymentUseCase.call(
        SubmitPaymentProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          otherField: '',
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
        break;

      case 2:
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
