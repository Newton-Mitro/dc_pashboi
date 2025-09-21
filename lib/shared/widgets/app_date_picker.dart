import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class AppDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final void Function(DateTime?) onDateChanged;
  final String label;
  final String? errorText;
  final Icon? prefixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled; // <- New property

  const AppDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.label,
    this.errorText,
    this.prefixIcon,
    this.firstDate,
    this.lastDate,
    this.enabled = true, // <- Default to true
  });

  Future<void> _selectDate(BuildContext context) async {
    if (!enabled) return; // Prevent opening when disabled

    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      helpText: label,
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: context.theme.colorScheme),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: context.theme.colorScheme.secondary,
        width: 1.0,
      ),
    );

    final formattedDate =
        selectedDate != null
            ? DateFormat('d MMM y').format(selectedDate!)
            : 'Select a date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: enabled ? () => _selectDate(context) : null,
          child: AbsorbPointer(
            absorbing: !enabled,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color:
                      enabled
                          ? context.theme.colorScheme.onSurface
                          : Colors.grey,
                ),
                filled: true,
                isDense: true,
                prefixIcon:
                    prefixIcon ??
                    Icon(
                      Icons.calendar_today,
                      color: enabled ? null : Colors.grey,
                    ), // Icon color when disabled
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.secondary,
                    width: 2,
                  ),
                ),
                enabledBorder: border,
                errorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.red),
                ),
                enabled: enabled,
              ),
              child: Text(
                formattedDate,
                style: TextStyle(
                  color:
                      enabled
                          ? context.theme.colorScheme.onSurface
                          : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 1.0, left: 8),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
