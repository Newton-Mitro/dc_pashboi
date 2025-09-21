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
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<LeaveApplicationBloc>().add(
  //     LeaveApplicationUpdateField(
  //       data: {"selectedLeaveType": widget.selectedLeaveTypeId},
  //     ),
  //   );
  // }

  int calculateTotalLeaveDays(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) return 0;

    return endDate.difference(startDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Application")),
      body: PageContainer(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return BlocBuilder<LeaveApplicationBloc, LeaveApplicationState>(
      builder: (context, state) {
        var data = state.leaveApplicationData;

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

                AppDropdownSelect<String>(
                  label: "Leave Type",
                  value:
                      (data["selectedLeaveType"] as String?)?.isEmpty ?? true
                          ? widget.selectedLeaveTypeId
                          : data["selectedLeaveType"] as String,
                  enabled: widget.leaveTypes.isNotEmpty,
                  items:
                      widget.leaveTypes
                          .map<DropdownMenuItem<String>>(
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
                (data["selectedLeaveType"] != '02' &&
                        data["selectedLeaveType"] != '03' &&
                        data["selectedLeaveType"] != '07')
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSearchTextInput(
                          initialValue: data["fallbackEmployeeCode"],
                          label: "Fallback Employee Id",
                          isSearch: true,
                          enabled: true,
                          prefixIcon: Icon(
                            FontAwesomeIcons.userTie,
                            color: context.theme.colorScheme.onSurface,
                          ),
                          errorText: '',
                          onChanged: (value) {
                            context.read<LeaveApplicationBloc>().add(
                              LeaveApplicationUpdateField(
                                data: {"fallbackEmployeeCode": value},
                              ),
                            );
                          },
                          onSearchPressed: () {
                            context.read<SearchEmployeeBloc>().add(
                              FetchSearchEmployeeEvent(
                                data["fallbackEmployeeCode"],
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
                            if (state is SearchEmployeeSuccess) {
                              final List<SearchEmployeeEntity> employees =
                                  state.employees;

                              context.read<LeaveApplicationBloc>().add(
                                LeaveApplicationUpdateField(
                                  data: {
                                    "accountHolderName":
                                        employees.first.fullName,
                                    'fallbackEmployeeCode':
                                        employees.first.employeeCode,
                                  },
                                ),
                              );

                              return AppTextInput(
                                initialValue: data["accountHolderName"],
                                label: 'Fallback Employee Name',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                enabled: false,
                                errorText: '',
                              );
                            }
                            return AppTextInput(
                              initialValue: data["accountHolderName"],
                              label: 'Fallback Employee Name',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              enabled: false,
                              errorText: '',
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                    : const SizedBox.shrink(),

                data["selectedLeaveType"] != '03'
                    ? Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: AppDatePicker(
                            label: "From Date",
                            enabled: true,
                            onDateChanged: (value) {
                              context.read<LeaveApplicationBloc>().add(
                                LeaveApplicationUpdateField(
                                  data: {"startDate": value},
                                ),
                              );
                            },
                            selectedDate: data["startDate"],
                          ),
                        ),

                        Expanded(
                          child: AppDatePicker(
                            label: "To Date",
                            enabled: true,
                            onDateChanged: (value) {
                              if (value != null) {
                                final rejoiningDate = value.add(
                                  const Duration(days: 1),
                                );

                                context.read<LeaveApplicationBloc>().add(
                                  LeaveApplicationUpdateField(
                                    data: {
                                      "endDate": value,
                                      "rejoiningDate": rejoiningDate,
                                    },
                                  ),
                                );
                              }
                            },
                            selectedDate: data["endDate"],
                          ),
                        ),
                      ],
                    )
                    : Column(
                      children: [
                        AppDateTimePicker(
                          selectedDateTime: data["startDate"],
                          onDateTimeChanged: (dateTime) {
                            setState(() {
                              context.read<LeaveApplicationBloc>().add(
                                LeaveApplicationUpdateField(
                                  data: {
                                    "startDate": dateTime!,
                                    "endDate": dateTime.add(
                                      const Duration(hours: 2, minutes: 30),
                                    ),
                                  },
                                ),
                              );

                              if (data['selectedLeaveType'] == '03') {
                                context.read<LeaveApplicationBloc>().add(
                                  LeaveApplicationUpdateField(
                                    data: {
                                      "rejoiningDate": dateTime.add(
                                        const Duration(hours: 2, minutes: 30),
                                      ),
                                    },
                                  ),
                                );
                              }
                            });
                          },
                          label: 'Form Date and Time',
                        ),

                        SizedBox(height: 16),
                        AppDateTimePicker(
                          selectedDateTime: data["endDate"],
                          onDateTimeChanged: (DateTime) {
                            setState(() {
                              // data["endDate"] = DateTime!;
                              // context.read<LeaveApplicationBloc>().add(
                              //   LeaveApplicationUpdateField(
                              //     data: {"endDate": DateTime},
                              //   ),
                              // );

                              // if (data['selectedLeaveType'] == '03') {
                              //   context.read<LeaveApplicationBloc>().add(
                              //     LeaveApplicationUpdateField(
                              //       data: {"rejoiningDate": DateTime},
                              //     ),
                              //   );
                              // }
                            });
                          },

                          label: 'To Data and Time',
                        ),
                      ],
                    ),

                const SizedBox(height: 16),
                (data["selectedLeaveType"] != '03')
                    ? Column(
                      children: [
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
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: context.theme.colorScheme.onSurface,
                                ),
                                enabled: false,
                                errorText: '',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppDatePicker(
                                label: "Rejoin Date",
                                selectedDate: data["rejoiningDate"],
                                enabled: true,
                                onDateChanged: (DateTime) {
                                  context.read<LeaveApplicationBloc>().add(
                                    LeaveApplicationUpdateField(
                                      data: {"rejoiningDate": DateTime},
                                    ),
                                  );
                                },
                                // selectedDate: data["rejoinDate"],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                    : const SizedBox.shrink(),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: data["description"],
                  // controller: _descriptionController,
                  maxLines: null,
                  minLines: 2,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
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
                BlocListener<LeaveApplicationBloc, LeaveApplicationState>(
                  listener: (context, state) {
                    if (state.error != null && state.error!.isNotEmpty) {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Oops!',
                          message: state.error!,
                          contentType: ContentType.failure,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }

                    if (state.successMessage != null &&
                        state.successMessage!.isNotEmpty) {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Done!',
                          message: state.successMessage!,
                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);

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
