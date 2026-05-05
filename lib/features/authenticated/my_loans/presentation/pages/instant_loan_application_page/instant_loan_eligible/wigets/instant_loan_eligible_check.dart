import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class InstantLoanEligibleCheck extends StatefulWidget {
  final List<dynamic> eligibleConditions;

  const InstantLoanEligibleCheck({super.key, required this.eligibleConditions});

  @override
  State<InstantLoanEligibleCheck> createState() =>
      _InstantLoanEligibleCheckState();
}

class _InstantLoanEligibleCheckState extends State<InstantLoanEligibleCheck> {
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
                Locales.string(
                  context,
                  'instant_loan_eligible_condition_check',
                ),
                style: TextStyle(
                  color: context.theme.colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.eligibleConditions.map((condition) {
            final isEligible = condition.isEligibile;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isEligible
                              ? context.theme.colorScheme.secondary.withOpacity(
                                0.1,
                              )
                              : context.theme.colorScheme.error.withOpacity(
                                0.1,
                              ),
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      isEligible
                          ? FontAwesomeIcons.circleCheck
                          : FontAwesomeIcons.circleXmark,
                      size: 18,
                      color:
                          isEligible
                              ? context.theme.colorScheme.secondary
                              : context.theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      condition.itemName,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.onSurface,
                        fontWeight:
                            isEligible ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
