import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/fallback_request_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_fallback_page/wigets/bloc/accepted_fallback_request_bloc.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/app_text_input.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LeaveFallbackPage extends StatefulWidget {
  final LeaveApplicationRequestModel data;

  const LeaveFallbackPage({super.key, required this.data});

  @override
  State<LeaveFallbackPage> createState() => _LeaveFallbackPageState();
}

class _LeaveFallbackPageState extends State<LeaveFallbackPage> {
  // Controllers
  final TextEditingController _leaveTypeController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  // Time values
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Date values
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _rejoinDate;

  @override
  void dispose() {
    _leaveTypeController.dispose();
    _employeeNameController.dispose();
    _totalDaysController.dispose();
    _reasonController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _leaveTypeController.text = widget.data.leaveType ?? '';
    _employeeNameController.text = widget.data.employeeName ?? '';
    _totalDaysController.text = widget.data.totalLeaveDays.toString() ?? '';
    _reasonController.text = widget.data.remarks ?? '';
    _startDate = widget.data.fromDate;
    _endDate = widget.data.toDate;
    _rejoinDate =
        widget.data.rejoiningDate.isNotEmpty
            ? DateTime.tryParse(widget.data.rejoiningDate)
            : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fallback Acceptance Details")),
      body: PageContainer(
        child: Container(
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
                            "Fallback Approval",
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
                        label: 'Leave Type',
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
                        label: 'Fallback Employee Name',
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
                              label: "Start Date",
                              errorText: '',
                              firstDate: null,
                              enabled: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppDatePicker(
                              selectedDate: _endDate,
                              onDateChanged:
                                  (d) => setState(() => _endDate = d),
                              label: "End Date",
                              errorText: '',
                              firstDate: null,
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextInput(
                              controller: _totalDaysController,
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
                              selectedDate: _rejoinDate,
                              onDateChanged:
                                  (d) => setState(() => _rejoinDate = d),
                              label: "Rejoin Date",
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
                        label: "Reason for Leave",
                        enabled: false,
                      ),
                      const SizedBox(height: 12),

                      _buildTextArea(
                        controller: _remarksController,
                        label: "Fallback Approval Remarks",
                      ),
                      const SizedBox(height: 16),

                      BlocListener<
                        AcceptedFallbackRequestBloc,
                        AcceptedFallbackRequestState
                      >(
                        listener: (context, state) {
                          if (state is AcceptedFallbackRequestError) {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Oops!',
                                message: state.message!,
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }

                          if (state is AcceptedFallbackRequestSuccess) {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Done!',
                                message: state.message!,
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
                          label: "Submit",
                          onPressed: () {
                            context.read<AcceptedFallbackRequestBloc>().add(
                              AcceptedFallbackRequestSubmitted(
                                leaveApplicationId:
                                    widget.data.leaveApplicationId ?? 0,
                                remarks: _remarksController.text.trim(),
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
      ),
    );
  }

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
          return 'Please enter a value';
        }
        return null;
      },
    );
  }
}
