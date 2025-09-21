import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_history_page/bloc/leave_history_bloc.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({super.key});

  @override
  State<LeaveHistoryPage> createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;

    _fetchLeaveApprovals();
  }

  void _fetchLeaveApprovals() {
    if (_startDate != null && _endDate != null) {
      context.read<LeaveHistoryBloc>().add(
        FetchLeaveHistory(fromDate: _startDate!, toDate: _endDate!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave History")),
      body: PageContainer(
        child: Column(
          children: [
            // Date pickers and button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppDatePicker(
                            selectedDate: _startDate,
                            onDateChanged:
                                (d) => setState(() => _startDate = d),
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
                  const SizedBox(height: 8),
                  AppPrimaryButton(
                    label: "Search",
                    onPressed: _fetchLeaveApprovals,
                  ),
                ],
              ),
            ),

            // Leave history list
            Expanded(
              child: BlocBuilder<LeaveHistoryBloc, LeaveHistoryState>(
                builder: (context, state) {
                  if (state is LeaveHistoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is LeaveHistoryError) {
                    return Center(
                      child: Text(
                        'An error occurred',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (state is LeaveHistorySuccess) {
                    final requestList = state.requests;

                    if (requestList.isEmpty) {
                      return const Center(
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
                              'There are currently no pending fallback requests',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: requestList.length,
                      itemBuilder: (context, index) {
                        final request = requestList[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: context.theme.colorScheme.surface,
                          elevation: 3,
                          shadowColor: context.theme.colorScheme.shadow,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.theme.colorScheme.primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              request.leaveType,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "From: ${MyDateUtils.formatDate(DateTime.tryParse(request.fromDate.toString()))}",
                                            ),
                                            Text(
                                              "To: ${MyDateUtils.formatDate(DateTime.tryParse(request.toDate.toString()))}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            context.theme.colorScheme.primary,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (true) // Replace `true` with your condition to show the "eye" button
                                            IconButton(
                                              icon: const Icon(
                                                FontAwesomeIcons.eye,
                                                size: 15,
                                              ),
                                              color:
                                                  context
                                                      .theme
                                                      .colorScheme
                                                      .onPrimary,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  AuthRoutesName
                                                      .leaveHistoryDetailsPage,
                                                  arguments: {
                                                    'leaveApproval': request,
                                                    'isEnable': false,
                                                  },
                                                );
                                              },
                                            ),

                                          if (request.currentStage == "Applied")
                                            IconButton(
                                              icon: const Icon(
                                                FontAwesomeIcons.penToSquare,
                                                size: 15,
                                              ),
                                              color:
                                                  context
                                                      .theme
                                                      .colorScheme
                                                      .onPrimary,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  AuthRoutesName
                                                      .leaveHistoryDetailsPage,
                                                  arguments: {
                                                    'leaveApproval': request,
                                                    'isEnable': true,
                                                  },
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  // Default fallback widget
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
