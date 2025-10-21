import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/taka_formatter.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/presentation/pages/product_loans_page/wigets/bloc/deposit_loan_product_bloc.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/ledger_input.dart';
import 'package:pashboi/shared/widgets/product_ledger_input.dart';

class CollateralDetails extends StatefulWidget {
  final String title;
  // final DepositLoanProductState state;
  final DepositLoanProductState ledgers;
  final void Function(ProductLoanCollectionAccountEntity) onToggleSelect;
  final void Function(ProductLoanCollectionAccountEntity, double)
  onAmountChanged;
  final String? sectionError;
  final Map<String, String>? amountErrors;

  const CollateralDetails({
    Key? key,
    required this.title,
    required this.ledgers,
    required this.onToggleSelect,
    required this.onAmountChanged,
    required this.sectionError,
    required this.amountErrors,
  }) : super(key: key);

  @override
  State<CollateralDetails> createState() => _CollateralDetailsState();
}

class _CollateralDetailsState extends State<CollateralDetails> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Calculates the total loanable amount from selected accounts
  double get totalSelectedLoanAmount {
    return widget.ledgers.collectionLedgers
        .where((ledger) => ledger.isSelected == true)
        .fold(0.0, (sum, ledger) => sum + (ledger.partialApplyLoan ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
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
          // Header
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

          // Body
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [],
                  children: [
                    ...widget.ledgers.collectionLedgers.map((stateLedger) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info Items and Checkbox Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      _InfoItem(
                                        icon: FontAwesomeIcons.layerGroup,
                                        label: "Account Type",
                                        value: stateLedger.accountType ?? "N/A",
                                      ),
                                      _InfoItem(
                                        icon: FontAwesomeIcons.hashtag,
                                        label: "Account Number",
                                        value:
                                            stateLedger.accountNumber ?? "N/A",
                                      ),
                                      _InfoItem(
                                        icon: FontAwesomeIcons.sackDollar,
                                        label: "Account Balance",
                                        value: TakaFormatter.format(
                                          stateLedger.totalBalance ?? 0,
                                        ),
                                      ),
                                      _InfoItem(
                                        icon: FontAwesomeIcons.coins,
                                        label: "Loanable Balance",
                                        value: TakaFormatter.format(
                                          stateLedger.partialApplyLoan ?? 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: stateLedger.isSelected,
                                  onChanged: (value) {
                                    widget.onToggleSelect(stateLedger);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // ProductLedgerInput(
                            //   ledger: stateLedger,
                            //   isSelected: stateLedger.isSelected!,
                            //   onAmountChanged: widget.onAmountChanged(
                            //     stateLedger,
                            //     value,
                            //   ),
                            // ),
                            AppTextInput(
                              label: "Apply Loan Amount",
                              prefixIcon: Icon(
                                FontAwesomeIcons.coins,
                                color: theme.colorScheme.onSurface,
                                size: 18,
                              ),
                              initialValue:
                                  stateLedger.partialApplyLoan.toString(),
                              enabled: stateLedger.isSelected!,
                              onChanged: (value) {
                                final amount = double.tryParse(value) ?? 0.0;
                                widget.onAmountChanged(stateLedger, amount);
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),

          // Footer with Total
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colorScheme.primary, width: 1.2),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Apply Loan Amount:",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  TakaFormatter.format(totalSelectedLoanAmount),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
