import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/submit_loan_against_deposit_product_usecase.dart';
part 'deposit_loan_product_event.dart';
part 'deposit_loan_product_state.dart';

class DepositLoanProductBloc
    extends Bloc<DepositLoanProductEvent, DepositLoanProductState> {
  static const int firstStep = 0;
  static const int lastStep = 4;
  static const int totalSteps = lastStep + 1;
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitLoanAgainstDepositProductUseCase
  submitLoanAgainstDepositProductUseCase;

  DepositLoanProductBloc({
    required this.getAuthUserUseCase,
    required this.submitLoanAgainstDepositProductUseCase,
  }) : super(DepositLoanProductState(currentStep: 0)) {
    on<DepositProductLoanGoToNextStep>(_onGoToNextStep);
    on<DepositProductLoanGoToPreviousStep>(_onGoToPreviousStep);
    on<SelectCardAccount>(_onSelectCardAccount);
    on<SelectDebitCard>(_onSelectDebitCard);
    on<ResetInstantLoanFlow>(_onResetFlow);
    on<UpdateStepData>(_onUpdateStepData);
    on<DepositProductLoanValidateStep>(_onValidateStep);
    on<SetLoanAccounts>(_onSetLoanAccounts);
    on<ToggleAccountSelection>(_onToggleAccountSelection);
    on<UpdateLoanAccountAmount>(_onUpdateLoanAmount);
    on<SubmitDepositLoanProduct>(_onSubmitDepositLoanApplication);
  }

  void _onSetLoanAccounts(
    SetLoanAccounts event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final selectedLoanAccount =
        event.ledgers
            .map(
              (ledger) => ledger.copyWith(
                accountNumber: ledger.accountNumber,
                accountType: ledger.accountType,
                totalBalance: ledger.totalBalance,
                loanableBalance: ledger.loanableBalance,
                withdrawableBalance: ledger.withdrawableBalance,
                partialApplyLoan: ledger.partialApplyLoan,
                isEligible: ledger.isEligible,
                isSelected: false,
              ),
            )
            .toList();

    emit(state.copyWith(selectedLoanAccounts: selectedLoanAccount));
  }

  void _onToggleAccountSelection(
    ToggleAccountSelection event,
    Emitter<DepositLoanProductState> emit,
  ) {
    late List<ProductLoanCollectionAccountEntity> updatedAccounts;

    updatedAccounts =
        state.loanAccounts.map((l) {
          if (l.accountNumber == event.ledger.accountNumber) {
            return l.copyWith(isSelected: !(l.isSelected!));
          }
          return l;
        }).toList();

    emit(state.copyWith(selectedLoanAccounts: [...updatedAccounts]));
  }

  void _onUpdateLoanAmount(
    UpdateLoanAccountAmount event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final updatedAccount =
        state.loanAccounts.map((l) {
          if (l.accountNumber == event.ledger.accountNumber) {
            return l.copyWith(partialApplyLoan: event.newAmount.toString());
          }
          return l;
        }).toList();

    emit(state.copyWith(selectedLoanAccounts: updatedAccount));
  }

  void _onValidateStep(
    DepositProductLoanValidateStep event,
    Emitter<DepositLoanProductState> emit,
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
    Emitter<DepositLoanProductState> emit,
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
    Emitter<DepositLoanProductState> emit,
  ) {
    emit(const DepositLoanProductState(currentStep: 0));
  }

  void _onSelectCardAccount(
    SelectCardAccount event,
    Emitter<DepositLoanProductState> emit,
  ) {
    emit(state.copyWith(selectedAccount: event.selectedCardAccount));
  }

  void _onSelectDebitCard(
    SelectDebitCard event,
    Emitter<DepositLoanProductState> emit,
  ) {
    emit(state.copyWith(selectedCard: event.selectedCard));
  }

  void _onGoToNextStep(
    DepositProductLoanGoToNextStep event,
    Emitter<DepositLoanProductState> emit,
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
    DepositProductLoanGoToPreviousStep event,
    Emitter<DepositLoanProductState> emit,
  ) {
    final current = state.currentStep;
    if (current > firstStep) {
      emit(state.copyWith(currentStep: current - 1));
    }
  }

  void _onSubmitDepositLoanApplication(
    SubmitDepositLoanProduct event,
    Emitter<DepositLoanProductState> emit,
  ) async {
    final authUserResult = await getAuthUserUseCase.call(NoParams());

    if (authUserResult.isLeft()) {
      emit(state.copyWith(error: 'User not found', isLoading: false));
      return;
    }

    final user = authUserResult.getOrElse(() => throw Exception()).user;

    final selectedLedgers =
        state.loanAccounts.where((l) => l.isSelected!).toList();

    final totalAmount = selectedLedgers.fold<double>(0.0, (sum, ledger) {
      double value = double.tryParse(ledger.partialApplyLoan) ?? 0.0;
      return sum + value;
    });

    final numberOfInstallment = state.stepData[1]?['installmentNo'];
    final interest = state.stepData[1]?['interest'];
    final maximumLoanAmount = state.stepData[1]?['MaximumLoanAmount'];
    final loanProductCode = state.stepData[1]?['productCode'];

    final accountResult = await submitLoanAgainstDepositProductUseCase.call(
      SubmitLoanAgainstDepositProductProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
        cardNo: state.selectedCard!.cardNumber,
        collateralAccounts: selectedLedgers,
        loanProductCode: loanProductCode,
        maximumLoanAmount: maximumLoanAmount,
        interestRate: interest,
        numberOfInstallment: numberOfInstallment,
        totalApplyLoan: totalAmount,
        secretKey:
            md5
                .convert(utf8.encode(state.stepData[3]?['cardPin'].trim()))
                .toString(),
        accountNo: state.selectedAccount!.number.toString(),
        nameOnCard: state.selectedCard!.nameOnCard.toLowerCase().trim(),
        oTPRegId: state.stepData[3]?['OTPRegId'],
        oTPValue: state.stepData[4]?['OTP'],
      ),
    );
    accountResult.fold(
      (failure) =>
          emit(state.copyWith(error: failure.message, isLoading: false)),
      (message) =>
          emit(state.copyWith(successMessage: message, isLoading: false)),
    );
  }

  Map<String, dynamic> _validateInstantLoanSteps(int step) {
    final data = state.stepData[step] ?? {};
    final errors = <String, dynamic>{};
    switch (step) {
      case 0:
        final selectedAccounts =
            state.loanAccounts
                .where((account) => account.isSelected == true)
                .toList();

        final selectedLedgers =
            state.loanAccounts.where((l) => l.isSelected!).toList();
        if (selectedLedgers.isEmpty) {
          errors['loanAccounts'] = 'Please select at least one ledger Account';
        } else {
          final Map<String, String> amountErrors = {};

          for (final account in selectedAccounts) {
            final amount =
                double.tryParse(account.partialApplyLoan.toString()) ?? 0;

            final double eligibleAmount = account.loanableBalance;
            final double maxLoanAmount = 100000;

            if (amount <= 0) {
              amountErrors[account.accountNumber.toString()] =
                  'Please enter a valid amount';
            } else if (amount % 1000 != 0) {
              amountErrors[account.accountNumber.toString()] =
                  'Amount must be a multiple of 1000 ৳';
            } else if (amount > maxLoanAmount) {
              amountErrors[account.accountNumber.toString()] =
                  'Maximum loan amount is ${state.stepData[1]?['MaximumLoanAmount']} ৳';
            } else if (amount > eligibleAmount) {
              amountErrors[account.accountNumber.toString()] =
                  'Loan amount exceeds eligible amount';
            }
          }
          if (amountErrors.isNotEmpty) {
            errors['amounts'] = amountErrors;
          }
        }

        if (selectedAccounts.isEmpty) {
          errors['loanAccounts'] =
              'Please select at least one eligible account';
        } else {
          for (final account in selectedAccounts) {
            final amount =
                double.tryParse(account.partialApplyLoan.toString()) ?? 0;

            final double eligibleAmount = account.loanableBalance;
            const double maxLoanAmount = 100000;

            if (amount <= 0) {
              errors['amount_${account.accountNumber}'] =
                  'Please enter a valid amount';
            } else if (amount % 1000 != 0) {
              errors['amount_${account.accountNumber}'] =
                  'Amount must be a multiple of 1000 ৳';
            } else if (amount > maxLoanAmount) {
              errors['amount_${account.accountNumber}'] =
                  'Maximum loan amount is 1,00,000 ৳';
            } else if (amount > eligibleAmount) {
              errors['amount_${account.accountNumber}'] =
                  'Loan amount exceeds eligible amount';
            }
          }
        }
        break;
      case 1:
        if (data['installmentNo'] == null ||
            data['installmentNo'].toString().isEmpty) {
          errors['installmentNo'] = 'Please enter a installment no';
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

      case 4:
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
