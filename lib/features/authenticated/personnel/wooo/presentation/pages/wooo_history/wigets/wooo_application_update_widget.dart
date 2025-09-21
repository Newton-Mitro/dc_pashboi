import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_type_entities.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/app_date_time_picker.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class WoooApplicationUpdateWidget extends StatelessWidget {
  final int activeTabIndex;
  final List<WoooTypeEntities> woooTypes;
  final String? selectedWoooType;
  final ValueChanged<String?> onWoooTypeChanged;

  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime? rejoiningDate;
  final ValueChanged<DateTime?> onFromDateChanged;
  final ValueChanged<DateTime?> onToDateChanged;

  final TextEditingController totalHoursController;
  final TextEditingController totalDaysController;
  final TextEditingController reasonController;

  final bool? isEditable;
  final WoooDataEntities? wooodataHistory;

  const WoooApplicationUpdateWidget({
    super.key,
    required this.activeTabIndex,
    required this.woooTypes,
    required this.selectedWoooType,
    required this.onWoooTypeChanged,
    required this.fromDate,
    required this.toDate,
    required this.rejoiningDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.totalHoursController,
    required this.totalDaysController,
    required this.reasonController,
    this.isEditable,
    this.wooodataHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type Dropdown
            AppDropdownSelect(
              value: selectedWoooType,
              items:
                  woooTypes
                      .map(
                        (woooType) => DropdownMenuItem(
                          value: woooType.woooTypeCode,
                          child: Text(woooType.woooTypeName),
                        ),
                      )
                      .toList(),
              onChanged: onWoooTypeChanged,
              enabled: isEditable!,
              label: "Leave Type",
            ),

            const SizedBox(height: 12),

            // From Date/Time Picker
            if (activeTabIndex == 1)
              AppDatePicker(
                label: "==From Date==",
                onDateChanged: onFromDateChanged,
                selectedDate: fromDate,
                enabled: isEditable!,
              ),

            if (activeTabIndex != 1)
              AppDateTimePicker(
                label: "==From Date Time==",
                selectedDateTime: fromDate,
                onDateTimeChanged: onFromDateChanged,
              ),

            const SizedBox(height: 12),

            // To Date/Time Picker
            if (activeTabIndex != 1)
              AppDateTimePicker(
                label: "==To Date Time==",
                selectedDateTime: toDate,
                onDateTimeChanged: onToDateChanged,
              ),

            if (activeTabIndex == 1)
              AppDatePicker(
                label: "==To Date==",
                onDateChanged: onToDateChanged,
                selectedDate: toDate,
                enabled: isEditable!,
              ),

            const SizedBox(height: 12),

            // Total Hours or Days
            if (activeTabIndex == 0)
              AppTextInput(
                label: "Total Hours",
                prefixIcon: const Icon(FontAwesomeIcons.clock),
                keyboardType: TextInputType.number,
                controller: totalHoursController,
                enabled: isEditable!,
              ),

            if (activeTabIndex == 1)
              AppTextInput(
                label: "Total Days",
                prefixIcon: const Icon(FontAwesomeIcons.clock),
                keyboardType: TextInputType.number,
                controller: totalDaysController,
                enabled: isEditable!,
              ),

            const SizedBox(height: 12),

            // Rejoin Date
            AppDatePicker(
              label: "==Rejoin Date==",
              onDateChanged: (_) {},
              selectedDate: rejoiningDate,
              enabled: isEditable!,
            ),

            const SizedBox(height: 12),

            TextFormField(
              enabled: isEditable!,
              controller: reasonController,
              maxLines: null,
              minLines: 2,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Reason for Leave',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_note),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a reason';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
