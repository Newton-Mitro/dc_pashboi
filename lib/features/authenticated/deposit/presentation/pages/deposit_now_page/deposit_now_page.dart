import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/deposit_for_section/deposit_for_section.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_now_page/bloc/deposit_now_steps_bloc.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transaction_details_section/transaction_details_section.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_now_page/parts/transaction_preview_section/transaction_preview_section.dart';
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

class DepositNowPage extends StatefulWidget {
  const DepositNowPage({super.key});

  @override
  State<DepositNowPage> createState() => _DepositNowPageState();
}

class _DepositNowPageState extends State<DepositNowPage> {
  Widget _buildProgressStepper(double width, DepositNowStepsState state) {
    final theme = context.theme.colorScheme;

    return ProgressStepper(
      width: width * 0.9,
      padding: 5,
      height: 50,
      color: theme.primary,
      stepCount: DepositNowStepsBloc.totalSteps,
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
              context.read<DepositNowStepsBloc>().add(
                UpdateStepData(
                  step: 4,
                  data: {'OTPRegId': state.successMessage},
                ),
              );
              context.read<DepositNowStepsBloc>().add(DepositNowGoToNextStep());
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

        BlocListener<DepositNowStepsBloc, DepositNowStepsState>(
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
              Navigator.pushReplacementNamed(
                context,
                AuthRoutesName.depositNowSuccessPage,
                arguments: {
                  'message': Locales.string(context, 'deposit_successful'),
                },
              );
            }
          },
        ),
      ],

      child: BlocBuilder<DepositNowStepsBloc, DepositNowStepsState>(
        builder: (context, depositNowStepsState) {
          final isFirstStep =
              depositNowStepsState.currentStep == DepositNowStepsBloc.firstStep;
          final isLastStep =
              depositNowStepsState.currentStep == DepositNowStepsBloc.lastStep;

          return Scaffold(
            appBar: AppBar(title: Text(Locales.string(context, 'deposit_now'))),
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
                            depositNowStepsState,
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
                                key: ValueKey(depositNowStepsState.currentStep),
                                child:
                                    _buildSteps(
                                      depositNowStepsState,
                                    )[depositNowStepsState.currentStep].widget,
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
                                        context.read<DepositNowStepsBloc>().add(
                                          DepositNowGoToPreviousStep(),
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
                                        if (depositNowStepsState.currentStep ==
                                            4) {
                                          context
                                              .read<DepositNowStepsBloc>()
                                              .add(DepositNowValidateStep(4));
                                          _verifyCardPIN(depositNowStepsState);
                                          return;
                                        }
                                        context.read<DepositNowStepsBloc>().add(
                                          DepositNowGoToNextStep(),
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
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  BlocBuilder<DepositNowStepsBloc, DepositNowStepsState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  BlocBuilder<CollectionLedgerBloc, CollectionLedgerState>(
                    builder: (context, state) {
                      if (state is CollectionLedgerLoading) {
                        return Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
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
                      bottom: true,
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

  void _setCollectionLedgers(List<CollectionLedgerEntity> newLedgers) {
    context.read<DepositNowStepsBloc>().add(
      SetCollectionLedgers(ledgers: newLedgers),
    );
  }

  void _verifyCardPIN(DepositNowStepsState depositNowStepsState) {
    context.read<DebitCardBloc>().add(
      DebitCardPinVerify(
        accountNumber: depositNowStepsState.selectedAccount!.number,
        cardNumber: depositNowStepsState.selectedCard!.cardNumber,
        nameOnCard:
            depositNowStepsState.selectedCard!.nameOnCard.toLowerCase().trim(),
        cardPIN:
            depositNowStepsState.stepData[depositNowStepsState
                .currentStep]?['cardPin'],
      ),
    );
  }

  List<StepItem> _buildSteps(DepositNowStepsState state) {
    final selectedLedgers = state.collectionLedgers;
    return [
      StepItem(
        icon: FontAwesomeIcons.moneyBillTransfer,
        widget: TransferFromSection(
          accountNumber: state.selectedAccount?.number,
          accountError:
              state.validationErrors[state.currentStep]?['transferFromAccount'],
          onAccountChanged: (debitCard, selectedAccount) {
            if (debitCard != null) {
              context.read<DepositNowStepsBloc>().add(
                SelectDebitCard(debitCard),
              );
            }
            if (selectedAccount != null) {
              context.read<DepositNowStepsBloc>().add(
                SelectCardAccount(selectedAccount),
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
        widget: DepositForSection(
          sectionTitle: Locales.string(context, 'deposit_for'),
          searchAccountNumber:
              state.stepData[state.currentStep]?['searchAccountNumber'],
          searchAccountNumberError:
              state.validationErrors[state.currentStep]?['searchAccountNumber'],
          searchedAccountHolderName:
              state.stepData[state.currentStep]?['searchedAccountHolderName'],
          searchedAccountHolderNameError:
              state.validationErrors[state
                  .currentStep]?['searchedAccountHolderName'],
          setCollectionLedgers: _setCollectionLedgers,
          onChangeSearchAccountNumber: (accountNumber) {
            context.read<DepositNowStepsBloc>().add(
              UpdateStepData(
                step: state.currentStep,
                data: {'searchAccountNumber': accountNumber},
              ),
            );
          },
          changeSearchAccountNumber: (String? accountNumber) {
            context.read<DepositNowStepsBloc>().add(
              UpdateStepData(
                step: state.currentStep,
                data: {'searchAccountNumber': accountNumber},
              ),
            );
          },
          changeSearchedAccountHolderName: (String? accountHolderName) {
            context.read<DepositNowStepsBloc>().add(
              UpdateStepData(
                step: state.currentStep,
                data: {'searchedAccountHolderName': accountHolderName},
              ),
            );
          },
          beneficiaryAccountNumber:
              state.stepData[state.currentStep]?['beneficiaryAccountNumber'],
          changeBeneficiaryAccountNumber: (String? accountNumber) {
            context.read<DepositNowStepsBloc>().add(
              UpdateStepData(
                step: state.currentStep,
                data: {'beneficiaryAccountNumber': accountNumber},
              ),
            );
          },
        ),
      ),
      StepItem(
        icon: FontAwesomeIcons.piggyBank,
        widget: TransactionDetailsSection(
          ledgers: selectedLedgers,
          onToggleSelect: (ledger) {
            context.read<DepositNowStepsBloc>().add(
              ToggleLedgerSelection(ledger),
            );
          },
          removeSavingAccountNumber: state.selectedAccount?.number,
          onToggleSelectAll: (selectAll) {
            context.read<DepositNowStepsBloc>().add(
              ToggleSelectAllLedgers(selectAll),
            );
          },
          onAmountChanged: (ledger, newAmount) {
            context.read<DepositNowStepsBloc>().add(
              UpdateLedgerAmount(ledger: ledger, newAmount: newAmount),
            );
          },
          sectionError: state.validationErrors[state.currentStep]?['ledgers'],
          amountErrors: state.validationErrors[state.currentStep]?['amounts'],
        ),
      ),

      StepItem(
        icon: FontAwesomeIcons.eye,
        widget: TransactionPreviewSection(collectionLedgers: selectedLedgers),
      ),
      StepItem(
        icon: FontAwesomeIcons.creditCard,
        widget: CardPinVerificationSection(
          cardNumber: state.selectedCard?.cardNumber,
          cardNumberError: state.validationErrors[0]?['selectedCardNumber'],
          cardPin: state.stepData[state.currentStep]?['cardPin'],
          cardPinError: state.validationErrors[state.currentStep]?['cardPin'],
          onCardPinChanged: (pin) {
            context.read<DepositNowStepsBloc>().add(
              UpdateStepData(step: state.currentStep, data: {'cardPin': pin}),
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
            context.read<DepositNowStepsBloc>().add(
              UpdateStepData(step: state.currentStep, data: {'OTP': otp}),
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
      child: BlocBuilder<DepositNowStepsBloc, DepositNowStepsState>(
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
              _submitDepositNow(state);
            },
          );
        },
      ),
    );
  }

  void _submitDepositNow(DepositNowStepsState state) {
    context.read<DepositNowStepsBloc>().add(SubmitDepositNow());
  }
}
