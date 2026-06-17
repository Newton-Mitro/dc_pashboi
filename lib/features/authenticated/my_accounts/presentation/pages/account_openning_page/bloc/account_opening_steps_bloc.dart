import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
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
        emit(
          state.copyWith(
            error: appLocalizationService.t('failed_to_load_user_info'),
            isLoading: false,
          ),
        );
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final cardPin = state.stepData[3]?['cardPin']?.trim() ?? '';

      final secretKey = md5.convert(utf8.encode(cardPin)).toString();

      final nominees =
          state.nominees
              .map(
                (nominee) => {
                  "PersonId": nominee.id,
                  "NomineePercentage": nominee.percentage,
                },
              )
              .toList();

      final accountResult = await openDepositAccountUseCase.call(
        OpenDepositAccountParams(
          dMSProductCode: "19",
          branchCode: "01",
          accountFor: 0,
          accountName: state.stepData[2]?['accountName'],
          interestRate: state.selectedTenure!.interestRate,
          duration: state.selectedTenure!.durationInMonths,
          installmentAmount: state.selectedTenureAmount!.depositAmount,
          txnAccountNumber: state.selectedAccount!.number,
          accountNo: state.selectedAccount!.number,
          applicationNo: '',
          interestPostingAccount: state.stepData[2]?['interestTransferAccount'],
          cardNo: state.selectedCard!.cardNumber,
          nameOnCard: state.selectedCard!.nameOnCard,
          secretKey: secretKey,
          otpRegId: state.stepData[4]?['OTPRegId'],
          otpValue: state.stepData[6]?['OTP'],
          introducers: [],
          accountHolders: [
            {
              "AccountHolderId": user.personId,
              "IsOrganization": false,
              "SavingsACNumber": state.stepData[2]?['interestTransferAccount'],
              "MembershipNumber": "",
            },
          ],
          nominees: nominees,
          accountOperators: [
            {
              "AccountHolderId": user.personId,
              "AccountOperatorId": user.personId,
            },
          ],
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
        if (data['accountForText'] != null) {
          errors['accountForText'] = 'Please enter account for text';
        }
        break;

      case 2:
        break;
      case 3:
        final nominees = state.nominees;
        if (nominees.isEmpty) {
          errors['nominees'] = appLocalizationService.t(
            'please_add_at_least_one_nominee',
          );
        } else {
          final totalShare = nominees.fold<double>(
            0,
            (sum, nominee) => sum + (nominee.percentage),
          );
          if (totalShare > 100) {
            errors['nominees'] = appLocalizationService.t(
              'total_nominee_share_cannot_exceed_100',
            );
          } else if (totalShare < 100) {
            errors['nominees'] = appLocalizationService.t(
              'total_nominee_share_must_be_exactly_100',
            );
          }
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
