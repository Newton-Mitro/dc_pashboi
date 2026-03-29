import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/bloc/wooo_type_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_history/wigets/bloc/update_wooo_request_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_history/wigets/wooo_application_update_widget.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class WoooDataHistoryDetailsPage extends StatefulWidget {
  final WoooDataEntities wooodataHistory;
  final bool isEditable;

  const WoooDataHistoryDetailsPage({
    super.key,
    required this.wooodataHistory,
    required this.isEditable,
  });

  @override
  State<WoooDataHistoryDetailsPage> createState() =>
      _WoooDataHistoryDetailsPageState();
}

class _WoooDataHistoryDetailsPageState extends State<WoooDataHistoryDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int _activeTabIndex = 0;
  String? selectedWoooType;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? rejoiningDate;
  final TextEditingController totalHoursController = TextEditingController();
  final TextEditingController totalDaysController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.wooodataHistory.isHourly == false ? 1 : 0,
    );

    _activeTabIndex = _tabController.index; // initialize based on tab

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeTabIndex = _tabController.index;
          _updateTotalHoursOrDays(); // Recalculate when switching tabs
        });
      }
    });

    // Set initial values from wooodataHistory
    final history = widget.wooodataHistory;

    totalDaysController.text = history.totalDays.toString();
    selectedWoooType = history.woooTypeCode;
    fromDate = _parseDate(history.fromDate);
    toDate = _parseDate(history.toDate);
    rejoiningDate = _parseDate(history.rejoiningDate);
    reasonController.text = history.reason ?? '';

    context.read<WoooTypeBloc>().add(FetchWoooTypeEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTotalHoursOrDays() {
    if (fromDate != null && toDate != null) {
      if (_activeTabIndex == 0) {
        // For Hours tab
        final diff = toDate!.difference(fromDate!);
        final totalHours = diff.inMinutes / 60.0;
        totalHoursController.text = totalHours.toStringAsFixed(1);
        rejoiningDate = toDate!.add(const Duration(days: 0));
      } else {
        // For Days tab
        final diff = toDate!.difference(fromDate!).inDays + 1;
        totalDaysController.text = diff.toString();
        rejoiningDate = toDate!.add(const Duration(days: 1));
      }
    } else {
      totalHoursController.clear();
      totalDaysController.clear();
      rejoiningDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Working Out Of Office"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "For Hours"), Tab(text: "For Days")],
          labelColor: context.theme.colorScheme.onPrimary,
          indicatorColor: Colors.white,
        ),
      ),
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<WoooTypeBloc, WoooTypeState>(
                  builder: (context, state) {
                    if (state is WoooTypeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WoooTypeError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: context.theme.colorScheme.error,
                          ),
                        ),
                      );
                    }
                    if (state is WoooTypeSuccess) {
                      final woooTypes = state.woooTypeEntities;
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          WoooApplicationUpdateWidget(
                            isEditable: widget.isEditable,
                            wooodataHistory: widget.wooodataHistory,
                            activeTabIndex: _activeTabIndex,
                            woooTypes: woooTypes,
                            selectedWoooType: selectedWoooType,
                            onWoooTypeChanged: (value) {
                              setState(() {
                                selectedWoooType = value;
                              });
                            },
                            fromDate: fromDate,
                            toDate: toDate,
                            rejoiningDate: rejoiningDate,
                            onFromDateChanged: (date) {
                              setState(() {
                                fromDate = date;
                                _updateTotalHoursOrDays();
                              });
                            },
                            onToDateChanged: (date) {
                              setState(() {
                                toDate = date;
                                _updateTotalHoursOrDays();
                              });
                            },
                            totalHoursController: totalHoursController,
                            totalDaysController: totalDaysController,
                            reasonController: reasonController,
                          ),

                          WoooApplicationUpdateWidget(
                            isEditable: widget.isEditable,
                            wooodataHistory: widget.wooodataHistory,
                            activeTabIndex:
                                widget.wooodataHistory.isHourly == true ? 0 : 1,
                            woooTypes: woooTypes,
                            selectedWoooType: selectedWoooType,
                            onWoooTypeChanged: (value) {
                              setState(() {
                                selectedWoooType = value;
                              });
                            },
                            fromDate: fromDate,
                            toDate: toDate,
                            rejoiningDate: rejoiningDate,
                            onFromDateChanged: (date) {
                              setState(() {
                                fromDate = date;
                                _updateTotalHoursOrDays();
                              });
                            },
                            onToDateChanged: (date) {
                              setState(() {
                                toDate = date;
                                _updateTotalHoursOrDays();
                              });
                            },
                            totalHoursController: totalHoursController,
                            totalDaysController: totalDaysController,
                            reasonController: reasonController,
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(height: 10),
              if (widget.isEditable)
                BlocListener<UpdateWoooRequestBloc, UpdateWoooRequestState>(
                  listener: (context, state) {
                    if (state is UpdateWoooRequestError) {
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
                    if (state is UpdateWoooRequestSuccess) {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Done!',
                          message:
                              "Working Out of Office application  Update successfully",
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
                    label: "Submit",
                    onPressed: () {
                      context.read<UpdateWoooRequestBloc>().add(
                        UpdateWoooApplication(
                          fromDate: fromDate.toString(),
                          toDate: toDate.toString(),
                          rejoiningDate: rejoiningDate.toString(),
                          reason: reasonController.text,
                          woooTypeCode: selectedWoooType!,
                          isHourly: _activeTabIndex == 0 ? true : false,
                          leaveApplicationId:
                              widget.wooodataHistory.employeeWoooId,
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
