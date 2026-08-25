import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/bkash_icon.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/deposit_for_section/deposit_for_section.dart';
import 'package:pashboi/features/authenticated/beneficiaries/presentation/pages/beneficiaries_bloc/beneficiaries_bloc.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_from_bkash_page/bloc/deposit_from_bkash_steps_bloc.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/widgets/transaction_details_section/transaction_details_section.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_from_bkash_page/parts/transaction_charge_preview_section/bloc/bkash_service_charge_bloc.dart';
import 'package:pashboi/features/authenticated/deposit/presentation/pages/deposit_from_bkash_page/parts/transaction_charge_preview_section/transaction__charge_preview_section.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:pashboi/shared/widgets/step_item.dart';

class DepositFromBkashPage extends StatefulWidget {
  const DepositFromBkashPage({super.key});

  @override
  State<DepositFromBkashPage> createState() => _DepositFromBkashPageState();
}

class _DepositFromBkashPageState extends State<DepositFromBkashPage> {
  Widget _buildProgressStepper(double width, DepositFromBkashStepsState state) {
    final theme = context.theme.colorScheme;

    return ProgressStepper(
      width: width * 0.9,
      padding: 5,
      height: 50,
      color: theme.primary,
      stepCount: DepositFromBkashStepsBloc.totalSteps,
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
            child:
                index - 1 == 3
                    ? BkashIcon()
                    : Icon(
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
        BlocListener<DepositFromBkashStepsBloc, DepositFromBkashStepsState>(
          listener: (context, state) {
            if (state.error != null) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: Locales.string(context, "oops"),
                  message: state.error!,
                  contentType: ContentType.failure,
                ),
              );

              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }

            if (state.bkashPaymentEntity != null) {
              Navigator.pushReplacementNamed(
                context,
                AuthRoutesName.createBkashPaymentPage,
                arguments: {
                  'paymentUrl': state.bkashPaymentEntity?.bkashUrl ?? '',
                },
              );
            }
          },
        ),
        BlocListener<BkashServiceChargeBloc, BkashServiceChargeState>(
          listener: (context, state) {
            if (state is BkashServiceChargeLoaded) {
              context.read<DepositFromBkashStepsBloc>().add(
                DepositFromBkashUpdateStepData(
                  step: 2,
                  data: {'serviceCharge': state.serviceCharge},
                ),
              );
            }

            if (state is BkashServiceChargeError) {
              context.read<DepositFromBkashStepsBloc>().add(
                DepositFromBkashGoToPreviousStep(),
              );
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: Locales.string(context, "oops"),
                  message: state.message,
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
      ],

      child: BlocBuilder<DepositFromBkashStepsBloc, DepositFromBkashStepsState>(
        builder: (context, depositNowStepsState) {
          final isFirstStep =
              depositNowStepsState.currentStep ==
              DepositFromBkashStepsBloc.firstStep;
          final isLastStep =
              depositNowStepsState.currentStep ==
              DepositFromBkashStepsBloc.lastStep;

          return Scaffold(
            appBar: AppBar(
              title: Text(Locales.string(context, 'deposit_from_bkash')),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  PageContainer(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 15,
                            bottom: 15,
                          ),
                          child: _buildProgressStepper(
                            width,
                            depositNowStepsState,
                          ),
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
                                      horizontalPadding: 5,
                                      iconBefore: const Icon(
                                        FontAwesomeIcons.angleLeft,
                                      ),
                                      label: Locales.string(
                                        context,
                                        'previous_button_text',
                                      ),
                                      onPressed: () {
                                        context
                                            .read<DepositFromBkashStepsBloc>()
                                            .add(
                                              DepositFromBkashGoToPreviousStep(),
                                            );
                                      },
                                    ),
                                AppPrimaryButton(
                                  horizontalPadding: 5,
                                  enabled:
                                      isLastStep &&
                                              depositNowStepsState
                                                      .stepData[2]?['serviceCharge'] ==
                                                  null
                                          ? false
                                          : isLastStep &&
                                              depositNowStepsState
                                                      .stepData[2]?['serviceCharge'] ==
                                                  0
                                          ? false
                                          : true,
                                  iconAfter: const Icon(
                                    FontAwesomeIcons.angleRight,
                                  ),
                                  label:
                                      isLastStep
                                          ? Locales.string(
                                            context,
                                            'proceed_with_bkash',
                                          )
                                          : Locales.string(
                                            context,
                                            "next_button_text",
                                          ),
                                  onPressed: () {
                                    if (isLastStep) {
                                      _submitDepositFromBkash();
                                    } else {
                                      context
                                          .read<DepositFromBkashStepsBloc>()
                                          .add(DepositFromBkashGoToNextStep());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<
                    DepositFromBkashStepsBloc,
                    DepositFromBkashStepsState
                  >(
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
    context.read<DepositFromBkashStepsBloc>().add(
      DepositFromBkashSetCollectionLedgers(ledgers: newLedgers),
    );
  }

  List<StepItem> _buildSteps(DepositFromBkashStepsState state) {
    final selectedLedgers = state.collectionLedgers;
    return [
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
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashUpdateStepData(
                step: state.currentStep,
                data: {'searchAccountNumber': accountNumber},
              ),
            );
          },
          changeSearchAccountNumber: (String? accountNumber) {
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashUpdateStepData(
                step: state.currentStep,
                data: {'searchAccountNumber': accountNumber},
              ),
            );
          },
          changeSearchedAccountHolderName: (String? accountHolderName) {
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashUpdateStepData(
                step: state.currentStep,
                data: {'searchedAccountHolderName': accountHolderName},
              ),
            );
          },
          beneficiaryAccountNumber:
              state.stepData[state.currentStep]?['beneficiaryAccountNumber'],
          changeBeneficiaryAccountNumber: (String? accountNumber) {
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashUpdateStepData(
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
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashToggleLedgerSelection(ledger),
            );
          },
          onToggleSelectAll: (selectAll) {
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashToggleSelectAllLedgers(selectAll),
            );
          },
          onAmountChanged: (ledger, newAmount) {
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashUpdateLedgerAmount(
                ledger: ledger,
                newAmount: newAmount,
              ),
            );
          },
          sectionError: state.validationErrors[state.currentStep]?['ledgers'],
          amountErrors: state.validationErrors[state.currentStep]?['amounts'],
        ),
      ),

      StepItem(
        icon: FontAwesomeIcons.eye,
        widget: TransactionChargePreviewSection(
          collectionLedgers: selectedLedgers,
          serviceCharge: state.stepData[2]?['serviceCharge'] ?? 0,
          onServiceChargeChange: (double serviceCharge) {
            context.read<DepositFromBkashStepsBloc>().add(
              DepositFromBkashUpdateStepData(
                step: 2,
                data: {'serviceCharge': serviceCharge},
              ),
            );
          },
        ),
      ),
    ];
  }

  void _submitDepositFromBkash() {
    context.read<DepositFromBkashStepsBloc>().add(DepositFromBkashSubmit());
  }
}
