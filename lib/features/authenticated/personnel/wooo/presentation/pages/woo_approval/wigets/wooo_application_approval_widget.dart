import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/app_date_time_picker.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';

class WoooApplicationApprovalWidget extends StatelessWidget {
  final int activeTabIndex;
  final TextEditingController selectedWoooType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime? rejoiningDate;
  final ValueChanged<DateTime?> onFromDateChanged;
  final ValueChanged<DateTime?> onToDateChanged;
  final TextEditingController totalHoursController;
  final TextEditingController totalDaysController;
  final TextEditingController reasonController;
  final bool isEditable;
  final String selectedId;
  final WoooDataEntities? wooodataHistory;
  final ValueChanged<String> onStatusChanged;
  final List<Map<String, dynamic>> status;

  const WoooApplicationApprovalWidget({
    super.key,
    required this.selectedWoooType,
    required this.activeTabIndex,
    required this.fromDate,
    required this.toDate,
    required this.rejoiningDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.totalHoursController,
    required this.totalDaysController,
    required this.reasonController,
    required this.isEditable,
    this.wooodataHistory,
    required this.status,
    required this.selectedId,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextInput(
                label: "Leave Type",
                prefixIcon: const Icon(FontAwesomeIcons.clock),
                keyboardType: TextInputType.number,
                controller: selectedWoooType,
                enabled: isEditable,
              ),

              if (activeTabIndex == 1)
                AppDatePicker(
                  label: "==From Date==",
                  onDateChanged: onFromDateChanged,
                  selectedDate: fromDate,
                  enabled: isEditable,
                ),

              if (activeTabIndex != 1)
                AppDateTimePicker(
                  label: "==From Date Time==",
                  selectedDateTime: fromDate,
                  onDateTimeChanged: onFromDateChanged,
                ),

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
                  enabled: isEditable,
                ),

              if (activeTabIndex == 0)
                AppTextInput(
                  label: "Total Hours",
                  prefixIcon: const Icon(FontAwesomeIcons.clock),
                  keyboardType: TextInputType.number,
                  controller: totalHoursController,
                  enabled: isEditable,
                ),

              if (activeTabIndex == 1)
                AppTextInput(
                  label: "Total Days",
                  prefixIcon: const Icon(FontAwesomeIcons.clock),
                  keyboardType: TextInputType.number,
                  controller: totalDaysController,
                  enabled: isEditable,
                ),

              AppDatePicker(
                label: "==Rejoin Date==",
                onDateChanged: (_) {},
                selectedDate: rejoiningDate,
                enabled: isEditable,
              ),

              TextFormField(
                enabled: isEditable,
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

              AppDropdownSelect(
                items:
                    status.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'],
                        child: Text(item['name']),
                      );
                    }).toList(),
                value: selectedId,
                onChanged: (value) => onStatusChanged(value as String),
                enabled: isEditable,
                label: "Status",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
