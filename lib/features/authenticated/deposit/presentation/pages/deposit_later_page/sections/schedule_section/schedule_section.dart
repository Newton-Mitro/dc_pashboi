import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';

class ScheduleSection extends StatefulWidget {
  final String sectionTitle;
  final String? monthlyDepositDate;
  final String? monthlyDepositDateError;
  final void Function(String? value) onMonthlyDepositDateChange;
  final String? numberOfMonth;
  final String? numberOfMonthError;
  final void Function(String? value) onNumberOfMonthsChange;

  const ScheduleSection({
    super.key,
    required this.sectionTitle,
    required this.monthlyDepositDate,
    required this.monthlyDepositDateError,
    required this.onMonthlyDepositDateChange,
    required this.numberOfMonth,
    required this.numberOfMonthError,
    required this.onNumberOfMonthsChange,
  });

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context, widget.sectionTitle),
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildFormBody(context),
        ),
      ],
    );
  }

  Widget _buildFormBody(BuildContext context) {
    final theme = context.theme;

    // Monthly Deposit Date options (1 to 25)
    final depositDates = List.generate(25, (index) => (index + 1).toString());

    // Number of Months options (1 to 12)
    final months = List.generate(12, (index) => (index + 1).toString());

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Monthly Deposit Date dropdown
          AppDropdownSelect(
            label: Locales.string(context, 'monthly_deposit_date'),
            value: widget.monthlyDepositDate,
            prefixIcon: FontAwesomeIcons.calendarDay,
            errorText: widget.monthlyDepositDateError,
            items:
                depositDates
                    .map(
                      (date) => DropdownMenuItem(
                        value: date,
                        child: Text("Day $date"),
                      ),
                    )
                    .toList(),
            onChanged: widget.onMonthlyDepositDateChange,
          ),

          const SizedBox(height: 16),

          // Number of Months dropdown
          AppDropdownSelect(
            label: Locales.string(context, 'number_of_months'),
            value: widget.numberOfMonth,
            errorText: widget.numberOfMonthError,
            prefixIcon: FontAwesomeIcons.arrowDown19,
            items:
                months
                    .map(
                      (month) => DropdownMenuItem(
                        value: month,
                        child: Text("$month Month${month != '1' ? 's' : ''}"),
                      ),
                    )
                    .toList(),
            onChanged: widget.onNumberOfMonthsChange,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
