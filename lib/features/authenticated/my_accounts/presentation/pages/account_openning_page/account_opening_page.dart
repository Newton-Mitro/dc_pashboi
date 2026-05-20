import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/family_and_relatives_bloc/family_and_relatives_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/bloc/account_opening_steps_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_holder_section/account_holder_section.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_nominee_section/account_nominee_section.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_opening_details_section/account_opening_details_section.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_preview_section/account_preview_section.dart';
import 'package:progress_stepper/progress_stepper.dart';

import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/card_pin_verification_section/card_pin_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/otp_verification_section/otp_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transfer_from_section/transfer_from_section.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';
import 'package:pashboi/shared/widgets/step_item.dart';

class AccountOpeningPage extends StatefulWidget {
  final String productCode;
  final String productName;
  const AccountOpeningPage({
    super.key,
    required this.productCode,
    required this.productName,
  });

  @override
  State<AccountOpeningPage> createState() => _AccountOpeningPageState();
}

class _AccountOpeningPageState extends State<AccountOpeningPage> {
  Widget _buildProgressStepper(double width, AccountOpeningStepsState state) {
    final theme = context.theme.colorScheme;

    return ProgressStepper(
      width: width * 0.9,
      padding: 5,
      height: 50,
      color: theme.primary,
      stepCount: AccountOpeningStepsBloc.totalSteps,
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
              _buildSteps(state)[index - 1].icon,
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return MultiBlocListener(
      listeners: [
        BlocListener<DebitCardBloc, DebitCardState>(
          listener: (context, state) {
            print(state);
            if (state.successMessage != null) {
              context.read<AccountOpeningStepsBloc>().add(
                AccountOpeningUpdateStepData(
                  step: 4,
                  data: {'OTPRegId': state.successMessage},
                ),
              );
              context.read<AccountOpeningStepsBloc>().add(
                AccountOpeningGoToNextStep(),
              );
            }
            if (state.error != null) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: Locales.string(context, 'oops'),
                  message: state.error!,
                  contentType: ContentType.failure,
                ),
              );

              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          },
        ),
        BlocListener<AccountOpeningStepsBloc, AccountOpeningStepsState>(
          listener: (context, state) {
            if (state.error != null) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: Locales.string(context, 'oops'),
                  message: state.error!,
                  contentType: ContentType.failure,
                ),
              );

              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }

            if (state.successMessage != null) {
              Navigator.of(context).pop();
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: Locales.string(context, 'oops'),
                  message: state.successMessage!,
                  contentType: ContentType.success,
                ),
              );

              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          },
        ),
      ],

      child: BlocBuilder<AccountOpeningStepsBloc, AccountOpeningStepsState>(
        builder: (context, accountOpeningStepsState) {
          final isFirstStep =
              accountOpeningStepsState.currentStep ==
              AccountOpeningStepsBloc.firstStep;
          final isLastStep =
              accountOpeningStepsState.currentStep ==
              AccountOpeningStepsBloc.lastStep;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "${Locales.string(context, "account_opening_page_title")} ${widget.productName.trim().toTitleCase()}",
              ),
            ),
            body: Stack(
              children: [
                PageContainer(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        child: _buildProgressStepper(
                          width,
                          accountOpeningStepsState,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                              key: ValueKey(
                                accountOpeningStepsState.currentStep,
                              ),
                              child:
                                  _buildSteps(
                                    accountOpeningStepsState,
                                  )[accountOpeningStepsState
                                      .currentStep].widget,
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
                                    label: Locales.string(
                                      context,
                                      'previous_button_text',
                                    ),
                                    onPressed: () {
                                      context
                                          .read<AccountOpeningStepsBloc>()
                                          .add(
                                            AccountOpeningGoToPreviousStep(),
                                          );
                                    },
                                  ),
                              isLastStep
                                  ? const SizedBox(width: 100)
                                  : AppPrimaryButton(
                                    horizontalPadding: 10,
                                    iconAfter: const Icon(
                                      FontAwesomeIcons.angleRight,
                                    ),
                                    label: Locales.string(
                                      context,
                                      'next_button_text',
                                    ),
                                    onPressed: () {
                                      if (accountOpeningStepsState
                                              .currentStep ==
                                          5) {
                                        context
                                            .read<AccountOpeningStepsBloc>()
                                            .add(AccountOpeningValidateStep(5));
                                        _verifyCardPIN(
                                          accountOpeningStepsState,
                                        );
                                        return;
                                      }
                                      context
                                          .read<AccountOpeningStepsBloc>()
                                          .add(AccountOpeningGoToNextStep());
                                    },
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<DebitCardBloc, DebitCardState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state.error != null) {
                      return SizedBox.shrink();
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
            bottomNavigationBar:
                isLastStep ? _buildSubmitButton(width, context) : null,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<BeneficiariesBloc>().add(FetchBeneficiaries());
    context.read<FamilyAndRelativesBloc>().add(FetchFamilyAndRelatives());
  }

  void _verifyCardPIN(AccountOpeningStepsState accountOpeningStepsState) {
    context.read<DebitCardBloc>().add(
      DebitCardPinVerify(
        accountNumber: accountOpeningStepsState.selectedAccount!.number,
        cardNumber: accountOpeningStepsState.selectedCard!.cardNumber,
        nameOnCard:
            accountOpeningStepsState.selectedCard!.nameOnCard
                .toLowerCase()
                .trim(),
        cardPIN:
            accountOpeningStepsState.stepData[accountOpeningStepsState
                .currentStep]?['cardPin'],
      ),
    );
  }

  List<StepItem> _buildSteps(AccountOpeningStepsState state) {
    return [
      StepItem(
        icon: FontAwesomeIcons.moneyBillTransfer,
        widget: TransferFromSection(
          accountNumber: state.selectedAccount?.number,
          accountError:
              state.validationErrors[state.currentStep]?['transferFromAccount'],
          onAccountChanged: (debitCard, selectedAccount) {
            if (debitCard != null) {
              context.read<AccountOpeningStepsBloc>().add(
                AccountOpeningSelectDebitCard(debitCard),
              );
              context.read<AccountOpeningStepsBloc>().add(
                AccountOpeningUpdateStepData(
                  step: 2,
                  data: {
                    'accountName': debitCard.nameOnCard.trim().toTitleCase(),
                  },
                ),
              );
            }
            if (selectedAccount != null) {
              context.read<AccountOpeningStepsBloc>().add(
                AccountOpeningSelectCardAccount(selectedAccount),
              );
              context.read<AccountOpeningStepsBloc>().add(
                AccountOpeningUpdateStepData(
                  step: 2,
                  data: {
                    'interestTransferAccount': selectedAccount.number.trim(),
                  },
                ),
              );
            }
          },
          selectedCardNumber: state.selectedCard?.cardNumber,
          accountTypeName: state.selectedAccount?.typeName,
          accountBalance: state.selectedAccount?.balance,
          accountWithdrawable: state.selectedAccount?.withdrawableBalance,
          accountOperatorName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
          accountHolderName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
          accountName: state.selectedCard?.nameOnCard.toTitleCase().trim(),
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.userTie,
        widget: AccountHolderSection(
          accountHolderName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
          accountForText: state.stepData[state.currentStep]?['accountFor'],
          accountOperatorName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.piggyBank,
        widget: AccountOpeningDetailsSection(
          productCode: widget.productCode,
          accountName: state.stepData[state.currentStep]?['accountName'],
          accountDuration:
              state.selectedTenure != null
                  ? state.selectedTenure!.durationInMonths
                  : 0,
          interestRate:
              state.selectedTenure != null
                  ? state.selectedTenure!.interestRate
                  : 0,
          interestTransferTo:
              state.stepData[state.currentStep]?['interestTransferAccount'],
          onTenureChanged: (selectedTenure) {
            context.read<AccountOpeningStepsBloc>().add(
              AccountOpeningSelectTenure(selectedTenure!),
            );
          },
          installmentAmount:
              state.selectedTenureAmount != null
                  ? state.selectedTenureAmount!.depositAmount
                  : 0,
          onTenureAmountChange: (selectedTenureAmount) {
            context.read<AccountOpeningStepsBloc>().add(
              AccountOpeningSelectTenureAmount(selectedTenureAmount!),
            );
          },
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.userShield,
        widget: AccountNomineeSection(
          onAddNominee: (nominee) {
            context.read<AccountOpeningStepsBloc>().add(
              AccountOpeningAddNominee(nominee),
            );
          },
          onRemoveNominee: (nominee) {
            context.read<AccountOpeningStepsBloc>().add(
              AccountOpeningRemoveNominee(nominee),
            );
          },
          nominees: state.nominees,
          sectionError: state.validationErrors[state.currentStep]?['nominees'],
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.eye,
        widget: AccountPreviewSection(
          accountName: state.stepData[2]?['accountName'],
          accountDuration:
              state.selectedTenure != null
                  ? state.selectedTenure!.durationInMonths
                  : 0,
          interestRate:
              state.selectedTenure != null
                  ? state.selectedTenure!.interestRate
                  : 0,
          interestTransferTo: state.stepData[2]?['interestTransferAccount'],
          installmentAmount:
              state.selectedTenureAmount != null
                  ? state.selectedTenureAmount!.depositAmount
                  : 0,
          nominees: state.nominees,
          accountType: state.selectedAccount?.typeName,
          accountHolderName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
          accountOperatorName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.creditCard,
        widget: CardPinVerificationSection(
          cardNumber: state.selectedCard?.cardNumber,
          cardNumberError: state.validationErrors[0]?['selectedCardNumber'],
          cardPin: state.stepData[state.currentStep]?['cardPin'],
          cardPinError: state.validationErrors[state.currentStep]?['cardPin'],
          onCardPinChanged: (pin) {
            context.read<AccountOpeningStepsBloc>().add(
              AccountOpeningUpdateStepData(
                step: state.currentStep,
                data: {'cardPin': pin},
              ),
            );
          },
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.key,
        widget: OtpVerificationSection(
          resendOTP: () {
            _verifyCardPIN(state);
          },
          onOtpChanged: (String otp) {
            context.read<AccountOpeningStepsBloc>().add(
              AccountOpeningUpdateStepData(
                step: state.currentStep,
                data: {'OTP': otp},
              ),
            );
          },
          otp: state.stepData[state.currentStep]?['OTP'] ?? '',
        ),
      ),
    ];
  }

  Widget _buildSubmitButton(double width, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: BlocBuilder<AccountOpeningStepsBloc, AccountOpeningStepsState>(
        builder: (context, state) {
          return ProgressSubmitButton(
            width: width - 10,
            height: 100,
            enabled: !state.isLoading,
            backgroundColor: context.theme.colorScheme.primary,
            progressColor: context.theme.colorScheme.secondary,
            foregroundColor: context.theme.colorScheme.onPrimary,
            label: Locales.string(
              context,
              "openable_accounts_page_open_an_account_title",
            ),
            onSubmit: () {
              _submitAccountOpening(state);
            },
          );
        },
      ),
    );
  }

  void _submitAccountOpening(AccountOpeningStepsState state) {
    context.read<AccountOpeningStepsBloc>().add(AccountOpeningSubmit());
  }
}
