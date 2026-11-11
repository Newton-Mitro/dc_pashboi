import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class AppDateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final void Function(DateTime?) onDateTimeChanged;
  final String label;
  final String? errorText;
  final Icon? prefixIcon;

  const AppDateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
    required this.label,
    this.errorText,
    this.prefixIcon,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      helpText: 'Select Date',
      builder:
          (context, child) => Theme(
            data: Theme.of(
              context,
            ).copyWith(colorScheme: context.theme.colorScheme),
            child: child!,
          ),
    );

    if (pickedDate == null || !context.mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          selectedDateTime != null
              ? TimeOfDay.fromDateTime(selectedDateTime!)
              : TimeOfDay.now(),
      helpText: 'Select Time',
      builder:
          (context, child) => Theme(
            data: Theme.of(
              context,
            ).copyWith(colorScheme: context.theme.colorScheme),
            child: child!,
          ),
    );

    if (pickedTime == null) return;

    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onDateTimeChanged(fullDateTime);
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Select date & time';
    return DateFormat('EEE, MMM d yyyy • h:mm a').format(dateTime);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickDateTime(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: context.theme.colorScheme.onSurface),
              filled: true,
              isDense: true,
              prefixIcon: prefixIcon ?? const Icon(Icons.event),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              focusedBorder: border.copyWith(
                borderSide: BorderSide(
                  color: context.theme.colorScheme.secondary,
                  width: 2,
                ),
              ),
              enabledBorder: border,
              errorBorder: border.copyWith(
                borderSide: BorderSide(color: context.theme.colorScheme.error),
              ),
            ),
            child: Text(
              _formatDateTime(selectedDateTime),
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 1.0, left: 8),
            child: Text(
              errorText!,
              style: TextStyle(
                color: context.theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
