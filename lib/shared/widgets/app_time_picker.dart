import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pashboi/core/extensions/app_context.dart';

class AppTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final void Function(TimeOfDay?) onTimeChanged;
  final String label;
  final String? errorText;
  final Icon? prefixIcon;
  final bool enabled; // New property

  const AppTimePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
    required this.label,
    this.errorText,
    this.prefixIcon,
    this.enabled = true, // default true
  });

  Future<void> _selectTime(BuildContext context) async {
    if (!enabled) return; // prevent interaction when disabled

    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? now,
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
      onTimeChanged(picked);
    }
  }

  String _formatTime(BuildContext context, TimeOfDay? time) {
    if (time == null) return 'Select a time';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt); // e.g., 4:30 PM
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color:
            enabled
                ? context.theme.colorScheme.secondary
                : Colors.grey, // grey border when disabled
        width: 1.0,
      ),
    );

    final textColor =
        enabled
            ? context.theme.colorScheme.onSurface
            : Colors.grey; // grey text when disabled

    final iconColor =
        enabled
            ? (prefixIcon?.color ?? context.theme.colorScheme.onSurface)
            : Colors.grey; // grey icon when disabled

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: enabled ? () => _selectTime(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: textColor),
              filled: true,
              isDense: true,
              prefixIcon:
                  prefixIcon != null
                      ? Icon(prefixIcon!.icon, color: iconColor)
                      : Icon(Icons.access_time, color: iconColor),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              focusedBorder: border.copyWith(
                borderSide: BorderSide(
                  color:
                      enabled
                          ? context.theme.colorScheme.secondary
                          : Colors.grey,
                  width: 2,
                ),
              ),
              enabledBorder: border,
              errorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            child: Text(
              _formatTime(context, selectedTime),
              style: TextStyle(color: textColor, fontSize: 16),
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
