import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class InstantLoanNotEligible extends StatefulWidget {
  final List<dynamic> eligibleConditions;

  const InstantLoanNotEligible({super.key, required this.eligibleConditions});

  @override
  State<InstantLoanNotEligible> createState() => _InstantLoanNotEligibleState();
}

class _InstantLoanNotEligibleState extends State<InstantLoanNotEligible> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: PageContainer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.faceFrown,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Sorry! You're not eligible for this loan.",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        "Eligibility Findings :-",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.error,
                        ),
                      ),

                      ...widget.eligibleConditions.map((condition) {
                        final isEligible = condition.isEligibile;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      isEligible
                                          ? theme.colorScheme.secondary
                                              .withOpacity(0.1)
                                          : theme.colorScheme.error.withOpacity(
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
                                          ? theme.colorScheme.secondary
                                          : theme.colorScheme.error,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  condition.itemName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight:
                                        isEligible
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: TextButton.icon(
                    icon: Icon(
                      FontAwesomeIcons.arrowLeft,
                      size: 14,
                      color: theme.colorScheme.onPrimary,
                    ),
                    label: Text(
                      "Close",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Or any other logic
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      backgroundColor: theme.colorScheme.primary.withOpacity(
                        0.50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
