import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/internal_transfer_page/sections/transfer_preview_section/transfer_preview_section.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/internal_transfer_page/sections/transfer_to_account_section/transfer_to_account_section.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/internal_transfer_page/bloc/internal_transfer_steps_bloc.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/transfer_to_bkash_page/parts/transfer_amount_section/transfer_amount_section.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:progress_stepper/progress_stepper.dart';

import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/card_pin_verification_section/card_pin_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/otp_verification_section/otp_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transfer_from_section/transfer_from_section.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';
import 'package:pashboi/shared/widgets/step_item.dart';

class InternalTransferPage extends StatefulWidget {
  const InternalTransferPage({super.key});

  @override
  State<InternalTransferPage> createState() => _InternalTransferPageState();
}

class _InternalTransferPageState extends State<InternalTransferPage> {
  Widget _buildProgressStepper(double width, InternalTransferStepsState state) {
    final theme = context.theme.colorScheme;

    return ProgressStepper(
      width: width * 0.9,
      padding: 5,
      height: 50,
      color: theme.primary,
      stepCount: InternalTransferStepsBloc.totalSteps,
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
            if (state.successMessage != null) {
              context.read<InternalTransferStepsBloc>().add(
                InternalTransferUpdateStepData(
                  step: 4,
                  data: {'OTPRegId': state.successMessage},
                ),
              );
              context.read<InternalTransferStepsBloc>().add(
                InternalTransferGoToNextStep(),
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
        BlocListener<InternalTransferStepsBloc, InternalTransferStepsState>(
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

            if (state.successMessage?.isNotEmpty ?? false) {
              Navigator.pushReplacementNamed(
                context,
                AuthRoutesName.internalTransferSuccessPage,
                arguments: {'message': state.successMessage!},
              );
            }
          },
        ),
      ],

      child: BlocBuilder<InternalTransferStepsBloc, InternalTransferStepsState>(
        builder: (context, depositLaterStepsState) {
          final isFirstStep =
              depositLaterStepsState.currentStep ==
              InternalTransferStepsBloc.firstStep;
          final isLastStep =
              depositLaterStepsState.currentStep ==
              InternalTransferStepsBloc.lastStep;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                Locales.string(context, 'transfer_within_dhaka_credit'),
              ),
            ),
            body: SafeArea(
              child: Stack(
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
                            depositLaterStepsState,
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
                                  depositLaterStepsState.currentStep,
                                ),
                                child:
                                    _buildSteps(
                                      depositLaterStepsState,
                                    )[depositLaterStepsState
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
                                            .read<InternalTransferStepsBloc>()
                                            .add(
                                              InternalTransferGoToPreviousStep(),
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
                                        if (depositLaterStepsState
                                                .currentStep ==
                                            4) {
                                          context
                                              .read<InternalTransferStepsBloc>()
                                              .add(
                                                InternalTransferValidateStep(4),
                                              );
                                          _verifyCardPIN(
                                            depositLaterStepsState,
                                          );
                                          return;
                                        }
                                        context
                                            .read<InternalTransferStepsBloc>()
                                            .add(
                                              InternalTransferGoToNextStep(),
                                            );
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
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state.error != null) {
                        return const SizedBox.shrink();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar:
                isLastStep
                    ? SafeArea(
                      top: false,
                      child: _buildSubmitButton(width, context),
                    )
                    : null,
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
  }

  void _verifyCardPIN(InternalTransferStepsState depositLaterStepsState) {
    context.read<DebitCardBloc>().add(
      DebitCardPinVerify(
        accountNumber: depositLaterStepsState.selectedAccount!.number,
        cardNumber: depositLaterStepsState.selectedCard!.cardNumber,
        nameOnCard:
            depositLaterStepsState.selectedCard!.nameOnCard
                .toLowerCase()
                .trim(),
        cardPIN:
            depositLaterStepsState.stepData[depositLaterStepsState
                .currentStep]?['cardPin'],
      ),
    );
  }

  List<StepItem> _buildSteps(InternalTransferStepsState state) {
    return [
      StepItem(
        icon: FontAwesomeIcons.moneyBillTransfer,
        widget: TransferFromSection(
          accountNumber: state.selectedAccount?.number,
          accountError:
              state.validationErrors[state.currentStep]?['transferFromAccount'],
          onAccountChanged: (debitCard, selectedAccount) {
            if (debitCard != null) {
              context.read<InternalTransferStepsBloc>().add(
                InternalTransferSelectDebitCard(debitCard),
              );
            }
            if (selectedAccount != null) {
              context.read<InternalTransferStepsBloc>().add(
                InternalTransferSelectCardAccount(selectedAccount),
              );
            }
          },

          selectedCardNumber: state.selectedCard?.cardNumber,
          accountTypeName: state.selectedAccount?.typeName,
          accountBalance:
              state.selectedAccount != null
                  ? state.selectedAccount!.balance
                  : 0,
          accountWithdrawable:
              state.selectedAccount != null
                  ? state.selectedAccount!.withdrawableBalance
                  : 0,
          accountOperatorName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
          accountHolderName:
              state.selectedCard?.nameOnCard.toTitleCase().trim(),
          accountName: state.selectedCard?.nameOnCard.toTitleCase().trim(),
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.magnifyingGlassChart,
        widget: TransferToAccountSection(
          sectionTitle: Locales.string(context, 'transfer_to_account'),
          searchAccountNumber:
              state.stepData[state.currentStep]?['searchAccountNumber'],
          searchAccountNumberError:
              state.validationErrors[state.currentStep]?['searchAccountNumber'],
          searchedAccountHolderName:
              state.stepData[state.currentStep]?['searchedAccountHolderName'],
          searchedAccountHolderNameError:
              state.validationErrors[state
                  .currentStep]?['searchedAccountHolderName'],
          onChangeSearchAccountNumber: (accountNumber) {
            context.read<InternalTransferStepsBloc>().add(
              InternalTransferUpdateStepData(
                step: state.currentStep,
                data: {'searchAccountNumber': accountNumber},
              ),
            );
          },
          changeSearchAccountNumber: (String? accountNumber) {
            context.read<InternalTransferStepsBloc>().add(
              InternalTransferUpdateStepData(
                step: state.currentStep,
                data: {'searchAccountNumber': accountNumber},
              ),
            );
          },
          changeSearchedAccountHolderName: (String? accountHolderName) {
            context.read<InternalTransferStepsBloc>().add(
              InternalTransferUpdateStepData(
                step: state.currentStep,
                data: {'searchedAccountHolderName': accountHolderName},
              ),
            );
          },
          beneficiaryAccountNumber:
              state.stepData[state.currentStep]?['beneficiaryAccountNumber'],
          changeBeneficiaryAccountNumber: (String? accountNumber) {
            context.read<InternalTransferStepsBloc>().add(
              InternalTransferUpdateStepData(
                step: state.currentStep,
                data: {'beneficiaryAccountNumber': accountNumber},
              ),
            );
          },
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.coins,
        widget: TransferAmountSection(
          sectionTitle: Locales.string(context, 'transfer_amount'),
          transferAmount:
              state.stepData[state.currentStep]?['transferAmount'] ?? '',
          transferAmountError:
              state.validationErrors[state.currentStep]?['transferAmount'],
          onTransferAmountChanged: (amount) {
            context.read<InternalTransferStepsBloc>().add(
              InternalTransferUpdateStepData(
                step: state.currentStep,
                data: {'transferAmount': amount},
              ),
            );
          },
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.eye,
        widget: TransferPreviewSection(
          transferAmount:
              double.tryParse(state.stepData[2]?['transferAmount'] ?? '') ??
              0.0,
          receiverName: state.stepData[1]?['searchedAccountHolderName'] ?? '',
          receiverAccountNumber:
              state.stepData[1]?['searchAccountNumber'] ?? '',
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
            context.read<InternalTransferStepsBloc>().add(
              InternalTransferUpdateStepData(
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
            context.read<InternalTransferStepsBloc>().add(
              InternalTransferUpdateStepData(
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
      child: BlocBuilder<InternalTransferStepsBloc, InternalTransferStepsState>(
        builder: (context, state) {
          return ProgressSubmitButton(
            width: width - 10,
            height: 100,
            enabled: !state.isLoading,
            backgroundColor: context.theme.colorScheme.primary,
            progressColor: context.theme.colorScheme.secondary,
            foregroundColor: context.theme.colorScheme.onPrimary,
            label: Locales.string(context, "press_and_hold_to_submit"),
            onSubmit: () {
              _submitInternalTransfer(state);
            },
          );
        },
      ),
    );
  }

  void _submitInternalTransfer(InternalTransferStepsState state) {
    context.read<InternalTransferStepsBloc>().add(
      InternalTransferSubmit(
        toAccountNumber: state.stepData[1]?['searchAccountNumber'] ?? '',
        transferAmount: double.parse(
          state.stepData[2]?['transferAmount'] ?? '0',
        ),
      ),
    );
  }
}
