import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_approval_page/bloc/leave_approval_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/app_icon_card.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({super.key});

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1); // First day of this month
    _endDate = now; // Today

    _fetchLeaveApprovals(); // Initial fetch
  }

  void _fetchLeaveApprovals() {
    if (_startDate != null && _endDate != null) {
      context.read<LeaveApprovalBloc>().add(
        FetchLeaveApprovals(
          fromDate: _startDate.toString(),
          toDate: _endDate.toString(),
        ),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Approval")),
      body: PageContainer(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(child: _buildForm()),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Pickers
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: AppDatePicker(
                    selectedDate: _startDate,
                    onDateChanged: (d) => setState(() => _startDate = d),
                    label: "Start Date",
                    errorText: '',
                    firstDate: null,
                    enabled: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppDatePicker(
                    selectedDate: _endDate,
                    onDateChanged: (d) => setState(() => _endDate = d),
                    label: "End Date",
                    errorText: '',
                    firstDate: null,
                    enabled: true,
                  ),
                ),
              ],
            ),
          ),

          // Search Button
          const SizedBox(height: 16),
          AppPrimaryButton(label: "Search", onPressed: _fetchLeaveApprovals),
          const SizedBox(height: 15),

          // Leave Approvals List
          BlocBuilder<LeaveApprovalBloc, LeaveApprovalState>(
            builder: (context, state) {
              if (state is LeaveApprovalLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is LeaveApprovalError) {
                return Center(
                  child: Text(
                    state.message ?? 'An error occurred',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is LeaveApprovalSuccess) {
                final requestList = state.approvals;

                if (requestList.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.boxOpen,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'There are currently no pending leave requests',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: requestList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final request = requestList[index];

                    return AppIconCard(
                      leftIcon: FontAwesomeIcons.mugHot,
                      rightIcon: FontAwesomeIcons.chevronRight,
                      boarderColor: context.theme.colorScheme.primary,
                      cardBody: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(request.employeeName),
                          Text("From: ${_formatDate(request.fromDate)}"),
                          Text("To:   ${_formatDate(request.toDate)}"),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AuthRoutesName.leaveApprovalDetailsPage,
                          arguments: {'leaveApproval': request},
                        );
                      },
                    );
                  },
                );
              }

              // Default empty view
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
