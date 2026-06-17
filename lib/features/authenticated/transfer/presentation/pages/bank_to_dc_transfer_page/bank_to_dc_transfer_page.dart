import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/string_casing_extension.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transfer_from_section/transfer_from_section.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/cards/presentation/pages/bloc/debit_card_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/entities/dc_bank_entity.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/bank_to_dc_transfer_page/sections/bank_transfer_info_section/bank_transfer_info_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transaction_details_section/transaction_details_section.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_now_page/parts/transaction_preview_section/transaction_preview_section.dart';
import 'package:pashboi/features/authenticated/transfer/presentation/pages/bank_to_dc_transfer_page/bloc/bank_to_dc_transfer_steps_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:progress_stepper/progress_stepper.dart';

import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/card_pin_verification_section/card_pin_verification_section.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/otp_verification_section/otp_verification_section.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/progress_submit_button/progress_submit_button.dart';
import 'package:pashboi/shared/widgets/step_item.dart';

class BankToDcTransferPage extends StatefulWidget {
  const BankToDcTransferPage({super.key});

  @override
  State<BankToDcTransferPage> createState() => _BankToDcTransferPageState();
}

class _BankToDcTransferPageState extends State<BankToDcTransferPage> {
  @override
  void initState() {
    // context.read<DebitCardBloc>().add(DebitCardLoad());
    context.read<BeneficiariesBloc>().add(FetchBeneficiaries());
    super.initState();
  }

  Widget _buildProgressStepper(double width, BankToDcTransferStepsState state) {
    final theme = context.theme.colorScheme;

    return ProgressStepper(
      width: width * 0.9,
      padding: 5,
      height: 50,
      color: theme.primary,
      stepCount: BankToDcTransferStepsBloc.totalSteps,
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
              context.read<BankToDcTransferStepsBloc>().add(
                BankToDcTransferUpdateStepData(
                  step: 4,
                  data: {'OTPRegId': state.successMessage},
                ),
              );
              context.read<BankToDcTransferStepsBloc>().add(
                BankToDcTransferGoToNextStep(),
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
        BlocListener<BankToDcTransferStepsBloc, BankToDcTransferStepsState>(
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
                AuthRoutesName.bankToDcTransferSuccessPage,
                arguments: {'message': state.successMessage},
              );
            }
          },
        ),
      ],

      child: BlocBuilder<BankToDcTransferStepsBloc, BankToDcTransferStepsState>(
        builder: (context, depositLaterStepsState) {
          final isFirstStep =
              depositLaterStepsState.currentStep ==
              BankToDcTransferStepsBloc.firstStep;
          final isLastStep =
              depositLaterStepsState.currentStep ==
              BankToDcTransferStepsBloc.lastStep;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                Locales.string(context, 'bank_to_dc_transfer_request'),
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
                              key: ValueKey(depositLaterStepsState.currentStep),
                              child:
                                  _buildSteps(
                                    depositLaterStepsState,
                                  )[depositLaterStepsState.currentStep].widget,
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
                                          .read<BankToDcTransferStepsBloc>()
                                          .add(
                                            BankToDcTransferGoToPreviousStep(),
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
                                      if (depositLaterStepsState.currentStep ==
                                          4) {
                                        context
                                            .read<BankToDcTransferStepsBloc>()
                                            .add(
                                              BankToDcTransferValidateStep(4),
                                            );
                                        _verifyCardPIN(depositLaterStepsState);
                                        return;
                                      }
                                      context
                                          .read<BankToDcTransferStepsBloc>()
                                          .add(BankToDcTransferGoToNextStep());
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
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state.error != null) {
                      return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
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

  void _setCollectionLedgers(DepositAccountEntity savingAccount, int amount) {
    context.read<BankToDcTransferStepsBloc>().add(
      BankToDcTransferSetCollectionLedgers(
        ledger: CollectionLedgerEntity(
          id: 0,
          accountNumber: savingAccount.number,
          accountName: savingAccount.name,
          ledgerName: savingAccount.typeName,
          accountTypeCode: savingAccount.typeCode,
          moduleCode: '0',
          amount: amount,
          depositAmount: amount,
          accountId: savingAccount.id,
          defaultAccount: false,
          subledger: false,
          multiplier: false,
          editable: true,
          lps: false,
          ledgerId: savingAccount.ledgerId,
          plType: 1,
          loanBalance: 0,
          intrestRate: 0,
          lastPaidDate: DateTime.now(),
          refundBased: false,
          collectionType: 'dms_balance',
          accountFor: 'Individual',
          isRefundBased: false,
          isSelected: true,
        ),
      ),
    );
  }

  void _verifyCardPIN(BankToDcTransferStepsState depositLaterStepsState) {
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

  List<StepItem> _buildSteps(BankToDcTransferStepsState state) {
    final selectedLedgers = state.collectionLedgers;
    return [
      StepItem(
        icon: FontAwesomeIcons.receipt,
        widget: TransferFromSection(
          sectionTitle: Locales.string(context, 'card_and_account'),
          accountNumber: state.selectedAccount?.number,
          accountError:
              state.validationErrors[state.currentStep]?['transferFromAccount'],
          onAccountChanged: (debitCard, selectedAccount) {
            if (debitCard != null) {
              context.read<BankToDcTransferStepsBloc>().add(
                BankToDcTransferSelectDebitCard(debitCard),
              );
            }
            if (selectedAccount != null) {
              context.read<BankToDcTransferStepsBloc>().add(
                BankToDcTransferSelectCardAccount(selectedAccount),
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
        icon: FontAwesomeIcons.buildingColumns,
        widget: BankTransferInfoSection(
          sectionTitle: Locales.string(context, 'proof_of_bank_transfer'),
          bankSelectionError:
              state.validationErrors[state.currentStep]?['bank'],
          selectedBankAccount: state.selectedBankAccount,
          onBankAccountChange: (DcBankEntity bankAccount) {
            context.read<BankToDcTransferStepsBloc>().add(
              BankToDcTransferSelectBankAccount(bankAccount),
            );
          },
          transactionId:
              state.stepData[state.currentStep]?['transactionId'] ?? '',
          onTransactionIdChange: (String tnxId) {
            context.read<BankToDcTransferStepsBloc>().add(
              BankToDcTransferUpdateStepData(
                step: state.currentStep,
                data: {'transactionId': tnxId},
              ),
            );
          },
          amount: state.stepData[state.currentStep]?['amount'] ?? '',
          amountError: state.validationErrors[state.currentStep]?['amount'],
          onAmountChange: (String amount) {
            if (amount.isEmpty) {
              return;
            }
            context.read<BankToDcTransferStepsBloc>().add(
              BankToDcTransferUpdateStepData(
                step: state.currentStep,
                data: {'amount': amount},
              ),
            );
            if (state.selectedAccount != null && amount.isNotEmpty) {
              _setCollectionLedgers(state.selectedAccount!, int.parse(amount));
            }
          },
          receiptFile: state.stepData[state.currentStep]?['receiptFile'],
          receiptError:
              state.validationErrors[state.currentStep]?['receiptFile'],
          onReceiptFileChange: (File? receiptFile) {
            context.read<BankToDcTransferStepsBloc>().add(
              BankToDcTransferUpdateStepData(
                step: state.currentStep,
                data: {'receiptFile': receiptFile},
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
            // context.read<BankToDcTransferStepsBloc>().add(
            //   BankToDcTransferToggleLedgerSelection(ledger),
            // );
          },
          onToggleSelectAll: (selectAll) {
            // context.read<BankToDcTransferStepsBloc>().add(
            //   BankToDcTransferToggleSelectAllLedgers(selectAll),
            // );
          },
          onAmountChanged: (ledger, newAmount) {
            // context.read<BankToDcTransferStepsBloc>().add(
            //   BankToDcTransferUpdateLedgerAmount(
            //     ledger: ledger,
            //     newAmount: newAmount,
            //   ),
            // );
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
            context.read<BankToDcTransferStepsBloc>().add(
              BankToDcTransferUpdateStepData(
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
            context.read<BankToDcTransferStepsBloc>().add(
              BankToDcTransferUpdateStepData(
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
      child: BlocBuilder<BankToDcTransferStepsBloc, BankToDcTransferStepsState>(
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
              _submitBankToDcTransfer(state);
            },
          );
        },
      ),
    );
  }

  void _submitBankToDcTransfer(BankToDcTransferStepsState state) {
    context.read<BankToDcTransferStepsBloc>().add(BankToDcTransferSubmit());
  }
}
