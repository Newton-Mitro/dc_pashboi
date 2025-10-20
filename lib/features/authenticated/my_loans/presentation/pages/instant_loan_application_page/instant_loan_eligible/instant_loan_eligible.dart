import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/card_pin_verification_section/card_pin_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/otp_verification_section/otp_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transfer_from_section/transfer_from_section.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/eligible_conditions_model.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_application_page/instant_loan_eligible/bloc/instant_loan_eligible_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_application_page/instant_loan_eligible/wigets/instant_loan_eligible_check.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/instant_loan_application_page/instant_loan_eligible/wigets/loan_information_and_amount.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';
import 'package:pashboi/shared/widgets/step_item.dart';
import 'package:progress_stepper/progress_stepper.dart';

class InstantLoanEligible extends StatefulWidget {
  final List<EligibleConditionsModel> eligibleConditions;
  const InstantLoanEligible({super.key, required this.eligibleConditions});

  @override
  State<InstantLoanEligible> createState() => _InstantLoanEligibleState();
}

class _InstantLoanEligibleState extends State<InstantLoanEligible> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<DebitCardBloc, DebitCardState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          context.read<InstantLoanEligibleBloc>().add(
            UpdateStepData(step: 3, data: {'OTPRegId': state.successMessage}),
          );
          context.read<InstantLoanEligibleBloc>().add(
            InstantLoanGoToNextStep(),
          );
        }
        if (state.error != null) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Oops!',
              message: state.error!,
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
        // TODO: implement listener
      },
      child: BlocBuilder<InstantLoanEligibleBloc, InstantLoanEligibleState>(
        builder: (context, state) {
          final steps = _buildSteps(state);
          final isFirstStep =
              state.currentStep == InstantLoanEligibleBloc.firstStep;
          final isLastStep =
              state.currentStep == InstantLoanEligibleBloc.lastStep;

          return Scaffold(
            body: Stack(
              children: [
                PageContainer(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: _buildProgressStepper(width, state, steps),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                      SafeArea(
                        maintainBottomViewPadding: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isFirstStep
                                  ? const SizedBox(width: 100)
                                  : AppPrimaryButton(
                                    horizontalPadding: 10,
                                    iconBefore: const Icon(
                                      FontAwesomeIcons.angleLeft,
                                    ),
                                    label: "Previous",
                                    onPressed: () {
                                      context
                                          .read<InstantLoanEligibleBloc>()
                                          .add(InstantLoanGoToPreviousStep());
                                    },
                                  ),
                              isLastStep
                                  ? const SizedBox(width: 100)
                                  : AppPrimaryButton(
                                    horizontalPadding: 10,
                                    iconAfter: const Icon(
                                      FontAwesomeIcons.angleRight,
                                    ),
                                    label: "Next",
                                    onPressed: () {
                                      if (state.currentStep == 3) {
                                        context
                                            .read<InstantLoanEligibleBloc>()
                                            .add(InstantLoanValidateStep(3));
                                        _verifyCardPIN(state);
                                        return;
                                      }
                                      context
                                          .read<InstantLoanEligibleBloc>()
                                          .add(InstantLoanGoToNextStep());
                                    },
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar:
                isLastStep ? _buildSubmitButton(width, context, state) : null,
          );
        },
      ),
    );
  }

  void _verifyCardPIN(InstantLoanEligibleState instantLoanEligibleState) {
    context.read<DebitCardBloc>().add(
      DebitCardPinVerify(
        accountNumber: instantLoanEligibleState.selectedAccount!.number,
        cardNumber: instantLoanEligibleState.selectedCard!.cardNumber,
        nameOnCard:
            instantLoanEligibleState.selectedCard!.nameOnCard
                .toLowerCase()
                .trim(),
        cardPIN:
            instantLoanEligibleState.stepData[instantLoanEligibleState
                .currentStep]?['cardPin'],
      ),
    );
  }

  Widget _buildSubmitButton(double width, BuildContext context, state) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ProgressSubmitButton(
        width: width - 10,
        height: 100,
        enabled: true,
        backgroundColor: context.theme.colorScheme.primary,
        progressColor: context.theme.colorScheme.secondary,
        foregroundColor: context.theme.colorScheme.onPrimary,
        label: 'Hold & Press to Submit',
        onSubmit: () {
          _submitInstantLoan(state); // Add your submit logic here
        },
      ),
    );
  }

  void _submitInstantLoan(InstantLoanEligibleState state) {
    context.read<InstantLoanEligibleBloc>().add(SubmitInstantLoan());
  }

  Widget _buildProgressStepper(
    double width,
    InstantLoanEligibleState state,
    List<StepItem> steps,
  ) {
    final theme = context.theme.colorScheme;

    return ProgressStepper(
      width: width * 0.9,
      padding: 5,
      height: 50,
      color: theme.primary,
      stepCount: InstantLoanEligibleBloc.totalSteps,
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

  List<StepItem> _buildSteps(InstantLoanEligibleState state) {
    return [
      StepItem(
        icon: FontAwesomeIcons.circleInfo,
        widget: InstantLoanEligibleCheck(
          eligibleConditions: widget.eligibleConditions,
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.sackDollar,
        widget: LoanInformationAndAmount(
          eligibleConditions: widget.eligibleConditions,
          onAmountChanged: (amount) {
            context.read<InstantLoanEligibleBloc>().add(
              UpdateStepData(step: state.currentStep, data: {'amount': amount}),
            );
          },
          amountError: state.validationErrors[state.currentStep]?['amount'],
          amount: state.stepData[state.currentStep]?['amount'].toString() ?? '',
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
              context.read<InstantLoanEligibleBloc>().add(
                SelectDebitCard(debitCard),
              );
            }
            if (selectedAccount != null) {
              context.read<InstantLoanEligibleBloc>().add(
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
            context.read<InstantLoanEligibleBloc>().add(
              UpdateStepData(step: state.currentStep, data: {'cardPin': pin}),
            );
          },
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.key,
        widget: OtpVerificationSection(
          onOtpChanged: (String otp) {
            context.read<InstantLoanEligibleBloc>().add(
              UpdateStepData(step: state.currentStep, data: {'OTP': otp}),
            );
          },
          resendOTP: () {
            _verifyCardPIN(state);
          },
        ),
      ),
    ];
  }
}
