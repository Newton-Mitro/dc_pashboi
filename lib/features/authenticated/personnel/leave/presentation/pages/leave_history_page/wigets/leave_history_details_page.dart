import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/fallback_request_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_type_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/search_employee_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_application_page/bloc/search_employee_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_history_page/wigets/bloc/update_leave_application_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_info_page/bloc/leave_type_bloc.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/app_date_time_picker.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';
import 'package:pashboi/shared/widgets/app_search_input.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LeaveHistoryDetailsPage extends StatefulWidget {
  final LeaveApplicationRequestModel data;
  final bool isEnable;

  const LeaveHistoryDetailsPage({
    super.key,
    required this.data,
    required this.isEnable,
  });

  @override
  State<LeaveHistoryDetailsPage> createState() =>
      _LeaveHistoryDetailsPageState();
}

class _LeaveHistoryDetailsPageState extends State<LeaveHistoryDetailsPage> {
  String? selectedLeaveType;
  final TextEditingController _accountSearchController =
      TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _applicationStatusController =
      TextEditingController();

  final TextEditingController _fallbackEmployeeCode = TextEditingController();

  TimeOfDay? _startTimeController;
  TimeOfDay? _endTimeController;
  late DateTime startDate;
  late DateTime endDate;
  late DateTime rejoinDate;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    startDate = widget.data.fromDate;
    endDate = widget.data.toDate;
    rejoinDate = DateTime.parse(widget.data.rejoiningDate);
    selectedLeaveType = widget.data.leaveTypeCode;
    _accountSearchController.text = widget.data.fallbackEmployeeCode ?? '';
    _accountHolderController.text = widget.data.fallbackPersonName ?? '';
    _applicationStatusController.text = widget.data.currentStage ?? '';
    _descriptionController.text = widget.data.remarks ?? '';
    _startTimeController = TimeOfDay.fromDateTime(startDate);
    _endTimeController = TimeOfDay.fromDateTime(endDate);
    _updateTotalDays();
    context.read<LeaveTypeBloc>().add(FetchLeaveTypeEvent());
  }

  void _handleDateChange(DateTime date, {required String field}) {
    setState(() {
      if (field == 'from') {
        startDate = date;
      }
      if (field == 'to') {
        endDate = date;
      }
      if (field == 'rejoin') {
        rejoinDate = date;
      }
      _updateTotalDays();
    });
  }

  void _updateTotalDays() {
    final days = endDate.difference(startDate).inDays + 1;
    _totalDaysController.text = days > 0 ? days.toString() : '0';
  }

  Widget _buildDatePicker({
    required DateTime date,
    required String label,
    required String field,
  }) {
    return AppDatePicker(
      selectedDate: date,
      onDateChanged: (d) => _handleDateChange(d!, field: field),
      label: label,
      errorText: _errorText,
      firstDate: null,
      lastDate: null,
      enabled: widget.isEnable,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave History Details")),
      body: PageContainer(
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
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
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Leave History",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<LeaveTypeBloc, LeaveTypeState>(
                        builder: (context, state) {
                          if (state is LeaveTypeLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is LeaveTypeError) {
                            return Text(
                              state.message,
                              style: TextStyle(
                                color: context.theme.colorScheme.error,
                              ),
                            );
                          }

                          if (state is LeaveTypeSuccess) {
                            final List<LeaveTypeEntity> leaveTypes =
                                state.leaveTypeEntity;

                            return AppDropdownSelect(
                              label: "Leave Type",
                              value: selectedLeaveType,
                              enabled: widget.isEnable,
                              items:
                                  leaveTypes
                                      .map(
                                        (type) => DropdownMenuItem<String>(
                                          value:
                                              type.id, // or type.name if your logic uses that
                                          child: Text(type.leaveType),
                                        ),
                                      )
                                      .toList(),
                              prefixIcon: FontAwesomeIcons.addressBook,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedLeaveType = newValue;
                                });
                              },
                            );
                          }

                          // Fallback for unexpected states
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 16),

                      if (selectedLeaveType != '02' &&
                          selectedLeaveType != '03')
                        Column(
                          children: [
                            AppSearchTextInput(
                              controller: _accountSearchController,
                              label: "Fallback Employee Id",
                              isSearch: true,
                              enabled: widget.isEnable,
                              prefixIcon: Icon(
                                FontAwesomeIcons.userTie,
                                color: context.theme.colorScheme.onSurface,
                              ),
                              errorText: '',
                              onSearchPressed: () {
                                final searchText =
                                    _accountSearchController.text.trim();
                                context.read<SearchEmployeeBloc>().add(
                                  FetchSearchEmployeeEvent(searchText),
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            BlocBuilder<
                              SearchEmployeeBloc,
                              SearchEmployeeState
                            >(
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
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                }

                                if (state is SearchEmployeeSuccess) {
                                  final List<SearchEmployeeEntity> employees =
                                      state.employees;
                                  final String fallbackName =
                                      employees.isNotEmpty
                                          ? employees.first.fullName
                                          : 'No Employee Found';

                                  final String fallbackEmpCode =
                                      employees.isNotEmpty
                                          ? employees.first.employeeCode
                                          : 'No Employee Found';

                                  _fallbackEmployeeCode.text = fallbackEmpCode;
                                  _accountHolderController.text = fallbackName;
                                }
                                return AppTextInput(
                                  controller: _accountHolderController,
                                  label: 'Fallback Employee Name',
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: context.theme.colorScheme.onSurface,
                                  ),
                                  enabled: widget.isEnable,
                                  errorText: '',
                                );

                                // Default fallback UI
                                // return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),

                      const SizedBox(height: 16),
                      selectedLeaveType != '03'
                          ? Row(
                            children: [
                              Expanded(
                                child: _buildDatePicker(
                                  date: startDate,
                                  label: "From Date",
                                  field: 'from',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDatePicker(
                                  date: endDate,
                                  label: "To Date",
                                  field: 'to',
                                ),
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              AppDateTimePicker(
                                selectedDateTime: startDate,
                                onDateTimeChanged: (DateTime) {
                                  setState(() {
                                    startDate = DateTime!;
                                    endDate = startDate.add(
                                      Duration(hours: 2, minutes: 30),
                                    );
                                  });
                                },
                                label: 'Form Date and Time',
                              ),
                              SizedBox(height: 16),
                              AppDateTimePicker(
                                selectedDateTime: endDate,
                                onDateTimeChanged: (DateTime) {
                                  setState(() {
                                    endDate = DateTime!; // fallback if null
                                  });
                                },

                                label: 'To Date and Time',
                              ),
                            ],
                          ),

                      const SizedBox(height: 16),

                      Column(
                        children: [
                          if (selectedLeaveType != '03')
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextInput(
                                    controller: _totalDaysController,
                                    label: 'Total Day(s)',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color:
                                          context.theme.colorScheme.onSurface,
                                    ),
                                    enabled: false,
                                    errorText: '',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDatePicker(
                                    date: rejoinDate,
                                    label: "Rejoin Date",
                                    field: 'rejoin',
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 16),

                          AppTextInput(
                            controller: _applicationStatusController,
                            label: 'Application Status',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: context.theme.colorScheme.onSurface,
                            ),
                            enabled: false,
                            errorText: '',
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _descriptionController,
                            maxLines: null,
                            minLines: 2,
                            enabled: widget.isEnable,
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
                          ),
                          const SizedBox(height: 16),

                          widget.isEnable
                              ? BlocListener<
                                UpdateLeaveApplicationBloc,
                                UpdateLeaveApplicationState
                              >(
                                listener: (context, state) {
                                  if (state is UpdateLeaveApplicationError) {
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Oops!',
                                        message: state.message,
                                        contentType: ContentType.failure,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  }

                                  if (state is UpdateLeaveApplicationSuccess) {
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Done!',
                                        message: state.message,
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

                                  // TODO: implement listener
                                },
                                child: AppPrimaryButton(
                                  label: "Apply",
                                  onPressed: () {
                                    context
                                        .read<UpdateLeaveApplicationBloc>()
                                        .add(
                                          UpdateLeaveApplication(
                                            remarks:
                                                _descriptionController.text
                                                    .trim(),
                                            fallbackEmployeeCode:
                                                _accountSearchController.text
                                                    .trim(),
                                            rejoiningDate:
                                                rejoinDate.toString(),
                                            toDate: endDate.toString(),
                                            formTime: startDate.toString(),
                                            toTime: endDate.toString(),
                                            fromDate: startDate.toString(),
                                            leaveTypeCode:
                                                selectedLeaveType.toString(),
                                            leaveStageRemarks: '',
                                            leaveApplicationId:
                                                widget.data.leaveApplicationId
                                                    .toString(),
                                          ),
                                        );
                                  },
                                ),
                              )
                              : AppPrimaryButton(
                                label: "close",
                                onPressed: () {},
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
