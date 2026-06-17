import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/eligible_conditions_model.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class LoanInformationAndAmount extends StatefulWidget {
  final List<EligibleConditionsModel> eligibleConditions;
  final void Function(String) onAmountChanged;
  final String? amount;
  final String? amountError;
  const LoanInformationAndAmount({
    super.key,
    required this.eligibleConditions,
    required this.onAmountChanged,
    required this.amount,
    required this.amountError,
  });

  @override
  State<LoanInformationAndAmount> createState() =>
      _LoanInformationAndAmountState();
}

class _LoanInformationAndAmountState extends State<LoanInformationAndAmount> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Center(
              child: Text(
                Locales.string(context, 'loan_information'),
                style: TextStyle(
                  color: context.theme.colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "You are eligible for Bronze instant loan up to Tk-10,000. Do you want to apply?",
                  widget.eligibleConditions[0].loanMemberType,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    // color: context.theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Center(
              child: Text(
                widget.eligibleConditions[0].loanAmountRules,

                // widget.eligibleConditions[0]?.itemName?.toString() ?? 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
            child: AppTextInput(
              initialValue: widget.amount,
              errorText: widget.amountError,
              label: Locales.string(context, 'enter_between_eligible_amount'),
              prefixIcon: Icon(FontAwesomeIcons.bangladeshiTakaSign),
              onChanged: widget.onAmountChanged,
            ),
          ),
        ],
      ),
    );
  }
}
