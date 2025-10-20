import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class ApplicationDetails extends StatefulWidget {
  final String title;

  const ApplicationDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<ApplicationDetails> createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
  bool isConfirmed = false;
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

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    final accountBalance = 703_575.0;
    final loanableBalance = 633_217.5;

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
                  children: [
                    // Container with Info Items, Checkbox and Input Box
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextInput(
                          // initialValue: widget.accountData.,
                          label: "Maximum Loan Amount",
                          prefixIcon: Icon(
                            FontAwesomeIcons.coins,
                            color: theme.colorScheme.onSurface,
                            size: 18,
                          ),
                          enabled: false,
                        ),
                        SizedBox(height: 5),

                        AppTextInput(
                          initialValue: "",

                          label: "Interest Rate",
                          prefixIcon: Icon(
                            FontAwesomeIcons.coins,
                            color: theme.colorScheme.onSurface,
                            size: 18,
                          ),
                          enabled: true,
                        ),
                        SizedBox(height: 5),

                        AppDropdownSelect(
                          items: [],
                          label: "Installment No",
                          onChanged: (p0) {},
                          value: "",
                        ),
                        SizedBox(height: 18),

                        AppTextInput(
                          label: "Apply Loan Amount",
                          prefixIcon: Icon(
                            FontAwesomeIcons.coins,
                            color: theme.colorScheme.onSurface,
                            size: 18,
                          ),
                          enabled: true,
                        ),
                      ],
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
}
