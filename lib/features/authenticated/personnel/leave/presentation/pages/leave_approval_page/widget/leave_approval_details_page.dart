import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/fallback_request_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_approval_page/widget/bloc/submit_leave_approval_bloc.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/app_time_picker.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LeaveApprovalDetailsPage extends StatefulWidget {
  final LeaveApplicationRequestModel data;
  const LeaveApprovalDetailsPage({super.key, required this.data});

  @override
  State<LeaveApprovalDetailsPage> createState() =>
      _LeaveApprovalDetailsPageState();
}

class _LeaveApprovalDetailsPageState extends State<LeaveApprovalDetailsPage> {
  final TextEditingController _leaveTypeController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _applicationStatusController =
      TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  TimeOfDay? _startTimeController;
  TimeOfDay? _endTimeController;

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _rejoinDate;

  @override
  void initState() {
    super.initState();
    _leaveTypeController.text = widget.data.leaveType;
    _employeeNameController.text = widget.data.fallbackPersonName;
    _totalDaysController.text = widget.data.totalLeaveDays.toString();
    _applicationStatusController.text = widget.data.currentStage;
    _reasonController.text = widget.data.remarks;
    _startDate = widget.data.fromDate;
    _endDate = widget.data.toDate;

    _startTimeController = TimeOfDay.fromDateTime(widget.data.fromDate);
    _endTimeController = TimeOfDay.fromDateTime(widget.data.toDate);

    _rejoinDate =
        widget.data.rejoiningDate.isNotEmpty
            ? DateTime.tryParse(widget.data.rejoiningDate)
            : null;
  }

  @override
  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
  }) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      maxLines: null,
      minLines: 2,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.edit_note),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return Locales.string(context, "please_enter_a_value");
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "leave_approval_details")),
      ),
      body: PageContainer(
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
                        child: Text(
                          Locales.string(context, "leave_approval_details"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    AppTextInput(
                      controller: _leaveTypeController,
                      label: Locales.string(context, "leave_type"),
                      prefixIcon: Icon(
                        FontAwesomeIcons.addressBook,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      enabled: false,
                      errorText: '',
                    ),
                    const SizedBox(height: 12),

                    AppTextInput(
                      controller: _employeeNameController,
                      label: Locales.string(context, "fallback_employee_id"),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      enabled: false,
                      errorText: '',
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: AppDatePicker(
                            selectedDate: _startDate,
                            onDateChanged:
                                (d) => setState(() => _startDate = d),
                            label: Locales.string(context, "from_date"),
                            errorText: '',
                            firstDate: null,
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDatePicker(
                            selectedDate: _endDate,
                            onDateChanged: (d) => setState(() => _endDate = d),
                            label: Locales.string(context, "to_date"),
                            errorText: '',
                            firstDate: null,
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (widget.data.leaveTypeCode == '03')
                      Row(
                        children: [
                          Expanded(
                            child: AppTimePicker(
                              enabled: false,
                              label: Locales.string(context, "start_time"),
                              selectedTime: _startTimeController,

                              onTimeChanged: (time) {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTimePicker(
                              label: Locales.string(context, "end_time"),
                              selectedTime: _endTimeController,
                              enabled: false,
                              onTimeChanged: (time) {},
                            ),
                          ),
                        ],
                      ),
                    if (_leaveTypeController == '03')
                      const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextInput(
                            controller: _totalDaysController,
                            label: Locales.string(context, "total_days"),
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
                            selectedDate: _rejoinDate,
                            onDateChanged:
                                (d) => setState(() => _rejoinDate = d),
                            label: Locales.string(context, "rejoin_date"),
                            errorText: '',
                            firstDate: null,
                            lastDate: null,
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _buildTextArea(
                      controller: _reasonController,
                      label: Locales.string(context, "reason_for_leave"),
                      enabled: false,
                    ),
                    const SizedBox(height: 12),

                    AppTextInput(
                      controller: _applicationStatusController,
                      label: Locales.string(context, "application_status"),
                      prefixIcon: Icon(
                        FontAwesomeIcons.faceSmile,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      enabled: false,
                      errorText: '',
                    ),
                    const SizedBox(height: 12),

                    _buildTextArea(
                      controller: _remarksController,
                      label: Locales.string(
                        context,
                        "fallback_approval_remarks",
                      ),
                    ),
                    const SizedBox(height: 16),

                    BlocListener<
                      SubmitLeaveApprovalBloc,
                      SubmitLeaveApprovalState
                    >(
                      listener: (context, state) {
                        if (state is SubmitLeaveApprovalError) {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: Locales.string(context, "oops"),
                              message: state.message,
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }

                        if (state is SubmitLeaveApprovalSuccess) {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: Locales.string(context, "success"),
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
                      },
                      child: AppPrimaryButton(
                        label: Locales.string(context, "submit"),
                        onPressed: () {
                          context.read<SubmitLeaveApprovalBloc>().add(
                            SubmitLeaveApprovals(
                              leaveStageRemarks: _remarksController.text.trim(),
                              leaveApplicationId:
                                  widget.data.leaveApplicationId,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
