import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/deposit_loan_product_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/product_loan_collection_account_bloc.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/step/bloc/fetch_against_loan_interest_bloc.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class ApplicationDetails extends StatefulWidget {
  final String title;
  final double totalAmount;
  final ProductLoanCollectionAccountSuccess accountData;
  final String accountIds;
  final String productCode;
  final DepositLoanProductState state;
  final void Function(String) selectInstallment;
  final String selectInstallmentData;
  final String? selectInstallmentError;

  const ApplicationDetails({
    Key? key,
    required this.title,
    required this.totalAmount,
    required this.accountData,
    required this.accountIds,
    required this.productCode,
    required this.selectInstallment,
    required this.state,
    required this.selectInstallmentData,
    required this.selectInstallmentError,
  }) : super(key: key);

  @override
  State<ApplicationDetails> createState() => _ApplicationDetailsState();
}

List<DropdownMenuItem<String>> buildInstallmentItems(String value) {
  if (value.isEmpty) return [];
  final parts = value.split(',').map((e) => e.trim()).toList();
  var item =
      parts
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList();
  return item;
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
  late final ScrollController _scrollController;
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // Trigger fetching interest data
    context.read<FetchAgainstLoanInterestBloc>().add(
      FetchAgainstLoanInterest(
        productCode: widget.productCode,
        accountIds: widget.accountIds,
      ),
    );

    context.read<DepositLoanProductBloc>().add(
      UpdateStepData(step: 1, data: {'installmentNo': widget.productCode}),
    );
    context.read<DepositLoanProductBloc>().add(
      UpdateStepData(step: 1, data: {'productCode': widget.productCode}),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return BlocBuilder<
      FetchAgainstLoanInterestBloc,
      FetchAgainstLoanInterestState
    >(
      builder: (context, state) {
        if (state is FetchAgainstLoanInterestLoading ||
            state is FetchAgainstLoanInterestInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FetchAgainstLoanInterestError) {
          return Center(child: Text(state.message));
        }

        if (state is FetchAgainstLoanInterestSuccess) {
          final productLoanInterest = state.againstLoanInterestEntity;

          context.read<DepositLoanProductBloc>().add(
            UpdateStepData(
              step: 1,
              data: {'MaximumLoanAmount': productLoanInterest.maxLoanAmount},
            ),
          );
          context.read<DepositLoanProductBloc>().add(
            UpdateStepData(
              step: 1,
              data: {'interest': productLoanInterest.interestRate},
            ),
          );

          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border.all(color: colorScheme.primary, width: 1.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // ===== Header =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // ===== Body =====
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---- Info Fields ----
                          AppTextInput(
                            initialValue:
                                productLoanInterest.maxLoanAmount.toString(),
                            label: Locales.string(
                              context,
                              'maximum_loan_amount',
                            ),
                            prefixIcon: Icon(
                              FontAwesomeIcons.coins,
                              color: theme.colorScheme.onSurface,
                              size: 18,
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 8),
                          AppTextInput(
                            initialValue:
                                productLoanInterest.interestRate.toString(),
                            // productLoanInterest,
                            label: Locales.string(context, 'interest_rate'),
                            prefixIcon: Icon(
                              FontAwesomeIcons.percent,
                              color: theme.colorScheme.onSurface,
                              size: 18,
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 8),
                          AppDropdownSelect(
                            items: buildInstallmentItems(
                              productLoanInterest.minimumInstallment,
                            ),
                            label: Locales.string(context, 'installment_no'),
                            onChanged: (value) {
                              widget.selectInstallment(value.toString());
                            },
                            value: widget.selectInstallmentData,
                            errorText: widget.selectInstallmentError,
                          ),
                          const SizedBox(height: 18),
                          AppTextInput(
                            label: Locales.string(context, 'apply_loan_amount'),
                            prefixIcon: Icon(
                              FontAwesomeIcons.moneyBillWave,
                              color: theme.colorScheme.onSurface,
                              size: 18,
                            ),
                            initialValue: widget.totalAmount.toString(),
                            enabled: false,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Fallback (should not happen)
        return const SizedBox.shrink();
      },
    );
  }
}
