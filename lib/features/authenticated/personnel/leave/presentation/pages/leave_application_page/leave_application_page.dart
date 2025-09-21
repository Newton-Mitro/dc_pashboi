import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_type_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/search_employee_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_application_page/bloc/search_employee_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_application_page/bloc/leave_application_bloc.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/app_date_time_picker.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_search_input.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LeaveApplicationPage extends StatefulWidget {
  final String selectedLeaveTypeId;
  final List<LeaveTypeEntity> leaveTypes;

  const LeaveApplicationPage({
    super.key,
    required this.selectedLeaveTypeId,
    required this.leaveTypes,
  });

  @override
  State<LeaveApplicationPage> createState() => _LeaveApplicationPageState();
}

class _LeaveApplicationPageState extends State<LeaveApplicationPage> {
  final TextEditingController _fallbackEmployeeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LeaveApplicationBloc>().add(
      LeaveApplicationUpdateField(
        data: {"selectedLeaveType": widget.selectedLeaveTypeId},
      ),
    );
  }

  @override
  void dispose() {
    _fallbackEmployeeController.dispose();
    super.dispose();
  }

  int calculateTotalLeaveDays(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) return 0;
    return endDate.difference(startDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Application")),
      body: PageContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return BlocBuilder<LeaveApplicationBloc, LeaveApplicationState>(
      builder: (context, state) {
        final data = state.leaveApplicationData;

        if (_fallbackEmployeeController.text !=
            (data["fallbackEmployeeCode"] ?? '')) {
          _fallbackEmployeeController.text = data["fallbackEmployeeCode"] ?? '';
        }

        final selectedLeaveType = data["selectedLeaveType"] as String?;

        return Card(
          color: context.theme.colorScheme.surface,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: context.theme.colorScheme.primary,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ListTile(
                  title: Text(
                    "Leave Application",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                /// Leave Type Dropdown
                AppDropdownSelect<String>(
                  label: "Leave Type",
                  value:
                      selectedLeaveType?.isEmpty ?? true
                          ? widget.selectedLeaveTypeId
                          : selectedLeaveType,
                  enabled: widget.leaveTypes.isNotEmpty,
                  items:
                      widget.leaveTypes
                          .map(
                            (type) => DropdownMenuItem<String>(
                              value: type.id,
                              child: Text(type.leaveType),
                            ),
                          )
                          .toList(),
                  prefixIcon: FontAwesomeIcons.addressBook,
                  onChanged: (value) {
                    context.read<LeaveApplicationBloc>().add(
                      LeaveApplicationUpdateField(
                        data: {"selectedLeaveType": value},
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                /// Fallback Employee
                if (selectedLeaveType != '02' &&
                    selectedLeaveType != '03' &&
                    selectedLeaveType != '07')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSearchTextInput(
                        controller: _fallbackEmployeeController,
                        label: "Fallback Employee Id",
                        isSearch: true,
                        enabled: true,
                        prefixIcon: Icon(
                          FontAwesomeIcons.userTie,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        errorText: '',
                        // onChanged: (value) {
                        //   context.read<LeaveApplicationBloc>().add(
                        //     LeaveApplicationUpdateField(
                        //       data: {"fallbackEmployeeCode": value},
                        //     ),
                        //   );
                        // },
                        onSearchPressed: () {
                          context.read<SearchEmployeeBloc>().add(
                            FetchSearchEmployeeEvent(
                              _fallbackEmployeeController.text,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<SearchEmployeeBloc, SearchEmployeeState>(
                        builder: (context, state) {
                          if (state is SearchEmployeeLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is SearchEmployeeError) {
                            return Text(
                              state.message,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                          if (state is SearchEmployeeSuccess &&
                              state.employees.isNotEmpty) {
                            final employee = state.employees.first;

                            context.read<LeaveApplicationBloc>().add(
                              LeaveApplicationUpdateField(
                                data: {
                                  "accountHolderName": employee.fullName,
                                  "fallbackEmployeeCode": employee.employeeCode,
                                },
                              ),
                            );

                            return AppTextInput(
                              initialValue: employee.fullName,
                              label: 'Fallback Employee Name',
                              enabled: false,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: context.theme.colorScheme.onSurface,
                              ),
                              errorText: '',
                            );
                          }

                          return AppTextInput(
                            initialValue: data["accountHolderName"],
                            label: 'Fallback Employee Name',
                            enabled: false,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: context.theme.colorScheme.onSurface,
                            ),
                            errorText: '',
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                /// Date Selection
                if (selectedLeaveType != '03')
                  Row(
                    children: [
                      Expanded(
                        child: AppDatePicker(
                          label: "From Date",
                          enabled: true,
                          selectedDate: data["startDate"],
                          onDateChanged: (value) {
                            context.read<LeaveApplicationBloc>().add(
                              LeaveApplicationUpdateField(
                                data: {"startDate": value},
                              ),
                            );
                          },
                          firstDate:
                              (selectedLeaveType == '01' ||
                                      selectedLeaveType == '04')
                                  ? DateTime.now()
                                  : null,
                          lastDate:
                              (selectedLeaveType == '02')
                                  ? DateTime.now()
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppDatePicker(
                          label: "To Date",
                          enabled: true,
                          selectedDate: data["endDate"],
                          onDateChanged: (value) {
                            if (value != null) {
                              final rejoin = value.add(Duration(days: 1));
                              context.read<LeaveApplicationBloc>().add(
                                LeaveApplicationUpdateField(
                                  data: {
                                    "endDate": value,
                                    "rejoiningDate": rejoin,
                                  },
                                ),
                              );
                            }
                          },
                          firstDate:
                              (selectedLeaveType == '01' ||
                                      selectedLeaveType == '04')
                                  ? DateTime.now()
                                  : null,
                          lastDate:
                              (selectedLeaveType == '02')
                                  ? DateTime.now()
                                  : null,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      AppDateTimePicker(
                        label: 'From Date and Time',
                        selectedDateTime: data["startDate"],
                        onDateTimeChanged: (dateTime) {
                          if (dateTime != null) {
                            final end = dateTime.add(
                              const Duration(hours: 2, minutes: 30),
                            );
                            context.read<LeaveApplicationBloc>().add(
                              LeaveApplicationUpdateField(
                                data: {
                                  "startDate": dateTime,
                                  "endDate": end,
                                  "rejoiningDate": end,
                                },
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      AppDateTimePicker(
                        label: 'To Date and Time',
                        selectedDateTime: data["endDate"],
                        onDateTimeChanged: (_) {},
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                /// Total Days + Rejoin Date
                if (selectedLeaveType != '03')
                  Row(
                    children: [
                      Expanded(
                        child: AppTextInput(
                          initialValue:
                              (data['startDate'] != null &&
                                      data['endDate'] != null)
                                  ? calculateTotalLeaveDays(
                                    data['startDate'],
                                    data['endDate'],
                                  ).toString()
                                  : '',
                          label: 'Total Day(s)',
                          enabled: false,
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: context.theme.colorScheme.onSurface,
                          ),
                          errorText: '',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppDatePicker(
                          label: "Rejoin Date",
                          selectedDate: data["rejoiningDate"],
                          enabled: true,
                          onDateChanged: (value) {
                            context.read<LeaveApplicationBloc>().add(
                              LeaveApplicationUpdateField(
                                data: {"rejoiningDate": value},
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                /// Reason for Leave
                TextFormField(
                  initialValue: data["description"],
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
                  onChanged: (value) {
                    context.read<LeaveApplicationBloc>().add(
                      LeaveApplicationUpdateField(data: {"description": value}),
                    );
                  },
                ),
                const SizedBox(height: 16),

                /// Submit Button + Snackbar
                BlocListener<LeaveApplicationBloc, LeaveApplicationState>(
                  listener: (context, state) {
                    if (state.error?.isNotEmpty ?? false) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Oops!',
                              message: state.error!,
                              contentType: ContentType.failure,
                            ),
                          ),
                        );
                    }
                    if (state.successMessage?.isNotEmpty ?? false) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Done!',
                              message: state.successMessage!,
                              contentType: ContentType.success,
                            ),
                          ),
                        );
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: AppPrimaryButton(
                    label: "Apply",
                    onPressed: () {
                      context.read<LeaveApplicationBloc>().add(
                        LeaveApplicationSubmitEvent(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
