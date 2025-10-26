import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/card_pin_verification_section/card_pin_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/otp_verification_section/otp_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transfer_from_section/transfer_from_section.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/deposit_loan_product_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/product_loan_collection_account_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/step/application_details.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/step/collateral_details.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';
import 'package:pashboi/shared/widgets/step_item.dart';
import 'package:progress_stepper/progress_stepper.dart';

class DepositLoanApplicationPage extends StatefulWidget {
  final String account;

  const DepositLoanApplicationPage({super.key, required this.account});

  @override
  State<DepositLoanApplicationPage> createState() =>
      _DepositLoanApplicationPageState();
}

class _DepositLoanApplicationPageState
    extends State<DepositLoanApplicationPage> {
  @override
  void initState() {
    super.initState();

    context.read<ProductLoanCollectionAccountBloc>().add(
      FetchProductLoanCollectionAccountEvent(widget.account),
    );
  }

  double calculateTotalSelectedLoanAmount(
    List<ProductLoanCollectionAccountEntity> accounts,
  ) {
    return accounts
        .where((ledger) => ledger.isSelected == true)
        .fold(
          0.0,
          (sum, ledger) =>
              sum +
              (double.tryParse(ledger.partialApplyLoan?.toString() ?? '0') ??
                  0.0),
        );
  }

  String getSelectedAccountIds(
    List<ProductLoanCollectionAccountEntity> ledgers,
  ) {
    final selectedIds =
        ledgers
            .where((ledger) => ledger.isSelected == true)
            .map((ledger) => ledger.id.toString()) // ensure it's a string
            .toList();

    return selectedIds.join(',');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Deposit Loan Application Form")),
      body: PageContainer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: BlocBuilder<
                  ProductLoanCollectionAccountBloc,
                  ProductLoanCollectionAccountState
                >(
                  builder: (context, state) {
                    if (state is ProductLoanCollectionAccountLoading ||
                        state is ProductLoanCollectionAccountInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ProductLoanCollectionAccountError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is ProductLoanCollectionAccountSuccess) {
                      final productLoan =
                          state.productLoanEligibleCollateralAccountDto;

                      context.read<DepositLoanProductBloc>().add(
                        SetLoanAccounts(
                          ledgers: productLoan.collateralAccounts,
                        ),
                      );
                      return _buildForm(width, state);
                    }

                    // Fallback in case state doesn't match any above
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            _buildBottomButtons(width),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(double width) {
    return SafeArea(
      child: BlocBuilder<DepositLoanProductBloc, DepositLoanProductState>(
        builder: (context, state) {
          final isFirstStep =
              state.currentStep == DepositLoanProductBloc.firstStep;
          final isLastStep =
              state.currentStep == DepositLoanProductBloc.lastStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous / Next buttons row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isFirstStep
                        ? const SizedBox(width: 100)
                        : AppPrimaryButton(
                          horizontalPadding: 10,
                          iconBefore: const Icon(FontAwesomeIcons.angleLeft),
                          label: "Previous",
                          onPressed: () {
                            context.read<DepositLoanProductBloc>().add(
                              DepositProductLoanGoToPreviousStep(),
                            );
                          },
                        ),
                    if (!isLastStep)
                      AppPrimaryButton(
                        horizontalPadding: 10,
                        iconAfter: const Icon(FontAwesomeIcons.angleRight),
                        label: "Next",
                        onPressed: () {
                          context.read<DepositLoanProductBloc>().add(
                            DepositProductLoanGoToNextStep(),
                          );
                        },
                      ),
                    if (isLastStep)
                      const SizedBox(width: 100), // to keep alignment
                  ],
                ),
              ),

              // Submit button (only on last step)
              if (isLastStep)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: BlocBuilder<
                    DepositLoanProductBloc,
                    DepositLoanProductState
                  >(
                    builder: (context, state) {
                      return ProgressSubmitButton(
                        width: width - 10, // match horizontal padding
                        height: 100,
                        enabled: !state.isLoading,
                        backgroundColor: context.theme.colorScheme.primary,
                        progressColor: context.theme.colorScheme.secondary,
                        foregroundColor: context.theme.colorScheme.onPrimary,
                        label: 'Hold & Press to Submit',
                        onSubmit: () {
                          // TODO: implement your submit logic here
                          // context.read<DepositLoanProductBloc>().add(
                          //   SubmitDepositLoan(),
                          // );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm(
    double width,
    ProductLoanCollectionAccountSuccess productLoan,
  ) {
    return BlocBuilder<DepositLoanProductBloc, DepositLoanProductState>(
      builder: (context, state) {
        final steps = _buildSteps(state, productLoan);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(widget.account),
            // Progress Stepper
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: _buildProgressStepper(width, state, steps),
            ),

            const SizedBox(height: 16),

            // Step Content (animated)
            SizedBox(
              height: 400, // Adjust height as needed
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                child: KeyedSubtree(
                  key: ValueKey(state.currentStep),
                  child: steps[state.currentStep].widget,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildProgressStepper(
    double width,
    DepositLoanProductState state,
    List<StepItem> steps,
  ) {
    final theme = context.theme.colorScheme;

    return ProgressStepper(
      width: width * 0.9,
      padding: 5,
      height: 50,
      color: theme.primary,
      stepCount: DepositLoanProductBloc.totalSteps,
      bluntHead: false,
      bluntTail: false,
      currentStep: state.currentStep,
      builder: (context, index, stepWidth) {
        final isCompleted = index - 1 <= state.currentStep;
        return ProgressStepWithChevron(
          width: stepWidth,
          height: 50,
          defaultColor: theme.surface,
          progressColor: theme.primary,
          borderColor: theme.primary,
          borderWidth: 2,
          wasCompleted: isCompleted,
          child: Center(
            child: Icon(
              steps[index - 1].icon,
              color:
                  isCompleted
                      ? theme.onPrimary
                      : theme.onSurface.withAlpha(220),
            ),
          ),
        );
      },
    );
  }

  List<StepItem> _buildSteps(
    DepositLoanProductState state,
    ProductLoanCollectionAccountSuccess productLoan,
  ) {
    return [
      StepItem(
        icon: FontAwesomeIcons.circleInfo,
        widget: CollateralDetails(
          title: "Collateral Details",
          ledgers: state,
          onToggleSelect: (data) {
            context.read<DepositLoanProductBloc>().add(
              ToggleAccountSelection(data),
            );
            context.read<DepositLoanProductBloc>().add(
              UpdateStepData(
                step: state.currentStep,
                data: {'loanAccount': data},
              ),
            );
          },
          onAmountChanged: (ledgers, newAmount) {
            context.read<DepositLoanProductBloc>().add(
              UpdateLoanAccountAmount(ledger: ledgers, newAmount: newAmount),
            );
          },
          onUpdateAccounts: (ledgers) {
            context.read<DepositLoanProductBloc>().add(
              UpdateStepData(
                step: state.currentStep,
                data: {'loanAccount': ledgers},
              ),
            );
          },
          // amountError:
          //     state.validationErrors[state
          //         .currentStep]?['amount_${widget.account}'],
          amountErrors: state.validationErrors[state.currentStep]?['amounts'],
          sectionError:
              state.validationErrors[state.currentStep]?['loanAccounts'] ?? '',
          totalAmount: calculateTotalSelectedLoanAmount(state.loanAccounts),
          // accountsErrors: state.validationErrors[state.currentStep]?['accounts'],
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.sackDollar,
        widget: ApplicationDetails(
          title: "Application Details",
          totalAmount: calculateTotalSelectedLoanAmount(state.loanAccounts),
          state: state,
          accountData: productLoan,
          accountIds: getSelectedAccountIds(state.loanAccounts),
          selectInstallment: (selectItem) {
            context.read<DepositLoanProductBloc>().add(
              UpdateStepData(
                step: state.currentStep,
                data: {'installmentNo': selectItem},
              ),
            );
          },
          selectInstallmentError:
              state.validationErrors[state.currentStep]?['installmentNo'],
          selectInstallmentData:
              state.stepData[state.currentStep]?['installmentNo'].toString() ??
              '',
          productCode: widget.account,
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.moneyBillTransfer,
        widget: TransferFromSection(
          sectionTitle: "Transfer To",
          accountNumber: state.selectedAccount?.number,
          accountError:
              state.validationErrors[state.currentStep]?['transferFromAccount'],
          accountBalance: state.selectedAccount?.balance ?? 0,
          onAccountChanged: (debitCard, selectedAccount) {
            if (debitCard != null) {
              context.read<DepositLoanProductBloc>().add(
                SelectDebitCard(debitCard),
              );
            }
            if (selectedAccount != null) {
              context.read<DepositLoanProductBloc>().add(
                SelectCardAccount(selectedAccount),
              );
            }
          },
          accountHolderName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
          selectedCardNumber: state.selectedCard?.cardNumber,
          accountName: state.selectedCard?.nameOnCard.toTitleCase().trim(),
          accountTypeName: state.selectedAccount?.typeName,
          accountWithdrawable: state.selectedAccount?.withdrawableBalance ?? 0,
          accountOperatorName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
        ),
      ),
      StepItem(
        icon: Icons.credit_card,
        widget: CardPinVerificationSection(
          cardNumber: state.selectedCard?.cardNumber,
          cardNumberError: state.validationErrors[0]?['selectedCardNumber'],
          cardPin: state.stepData[state.currentStep]?['cardPin'],
          cardPinError: state.validationErrors[state.currentStep]?['cardPin'],
          onCardPinChanged: (pin) {
            context.read<DepositLoanProductBloc>().add(
              UpdateStepData(step: state.currentStep, data: {'cardPin': pin}),
            );
          },
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.key,
        widget: OtpVerificationSection(
          onOtpChanged: (String otp) {
            // Update OTP logic here
          },
          resendOTP: () {
            // Resend OTP logic here
          },
        ),
      ),
    ];
  }
}
