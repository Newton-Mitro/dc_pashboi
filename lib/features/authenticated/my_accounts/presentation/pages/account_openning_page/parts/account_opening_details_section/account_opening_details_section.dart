import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/tenure_amount_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/tenure_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_opening_details_section/bloc/tenure_amount_bloc/tenure_amount_bloc.dart';
import 'package:pashboi/features/authenticated/my_accounts/presentation/pages/account_openning_page/parts/account_opening_details_section/bloc/tenure_bloc/tenure_bloc.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class AccountOpeningDetailsSection extends StatefulWidget {
  const AccountOpeningDetailsSection({
    super.key,
    required this.productCode,
    required this.accountName,
    required this.accountDuration,
    required this.interestRate,
    required this.interestTransferTo,
    required this.onTenureChanged,
    required this.installmentAmount,
    required this.onTenureAmountChange,
    this.accountNameError,
    this.accountDurationError,
    this.installmentAmountError,
  });

  final String? accountName;
  final String productCode;
  final int accountDuration;
  final double interestRate;
  final String? interestTransferTo;

  final String? accountDurationError;
  final ValueChanged<TenureEntity?> onTenureChanged;

  final double installmentAmount;
  final String? installmentAmountError;
  final ValueChanged<TenureAmountEntity?> onTenureAmountChange;

  final String? accountNameError;

  @override
  State<AccountOpeningDetailsSection> createState() =>
      _AccountOpeningDetailsSectionState();
}

class _AccountOpeningDetailsSectionState
    extends State<AccountOpeningDetailsSection> {
  @override
  void initState() {
    context.read<TenureBloc>().add(FetchTenuresEvent(widget.productCode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            border: Border.all(color: context.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    Locales.string(context, 'account_opening_details'),
                    style: TextStyle(
                      color: context.theme.colorScheme.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AppTextInput(
                      controller: TextEditingController(
                        text: widget.accountName,
                      ),
                      label: Locales.string(context, 'account_name'),
                      errorText: widget.accountNameError,
                      prefixIcon: Icon(
                        FontAwesomeIcons.user,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<TenureBloc, TenureState>(
                      builder: (context, state) {
                        var tenures =
                            state is TenureSuccess ? state.tenures : [];

                        final Map<int, TenureEntity> uniqueMap = {};

                        for (final tenure in tenures) {
                          uniqueMap.putIfAbsent(
                            tenure.durationInMonths,
                            () => tenure,
                          );
                        }

                        var filteredTenures = uniqueMap.values.toList();
                        return AppDropdownSelect<String>(
                          value: widget.accountDuration.toString(),
                          errorText: widget.accountDurationError,
                          label: Locales.string(context, 'tenure'),
                          enabled: filteredTenures.isNotEmpty,
                          items:
                              filteredTenures
                                  .map(
                                    (tenure) => DropdownMenuItem(
                                      value: tenure.durationInMonths.toString(),
                                      child: Text(tenure.durationName),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            final TenureEntity selected = tenures.firstWhere(
                              (t) => t.durationInMonths.toString() == value,
                            );
                            // Updating values for duration and interest rate
                            widget.onTenureChanged(selected);
                            context.read<TenureAmountBloc>().add(
                              FetchTenureAmountsEvent(
                                productCode: widget.productCode,
                                duration: selected.durationInMonths.toString(),
                              ),
                            );
                          },
                          prefixIcon: Icons.calendar_today,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AppTextInput(
                      controller: TextEditingController(
                        text: widget.accountDuration.toString(),
                      ),
                      enabled: false,
                      label: Locales.string(context, 'duration_in_months'),
                      prefixIcon: Icon(
                        FontAwesomeIcons.calendar,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTextInput(
                      controller: TextEditingController(
                        text: widget.interestRate.toString(),
                      ),
                      enabled: false,
                      label: Locales.string(context, 'interest_rate'),
                      prefixIcon: Icon(
                        FontAwesomeIcons.percent,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<TenureAmountBloc, TenureAmountState>(
                      builder: (context, state) {
                        var tenureAmounts =
                            state is TenureAmountSuccess
                                ? state.tenureAmounts
                                : [];
                        return AppDropdownSelect<String>(
                          value: widget.installmentAmount.toString(),
                          errorText: widget.installmentAmountError,
                          label: Locales.string(context, 'installment_amount'),
                          enabled: tenureAmounts.isNotEmpty,
                          items:
                              tenureAmounts
                                  .map(
                                    (amount) => DropdownMenuItem(
                                      value: amount.depositAmount.toString(),
                                      child: Text(
                                        amount.depositAmount.toString(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            final selected = tenureAmounts.firstWhere(
                              (t) => t.depositAmount.toString() == value,
                            );
                            // Updating values for duration and interest rate
                            widget.onTenureAmountChange(selected);
                          },
                          prefixIcon: Icons.attach_money,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AppTextInput(
                      controller: TextEditingController(
                        text: widget.interestTransferTo,
                      ),
                      label: Locales.string(
                        context,
                        'interest_transfer_account',
                      ),
                      prefixIcon: Icon(
                        FontAwesomeIcons.buildingColumns,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
