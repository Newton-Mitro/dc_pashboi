import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/woo_approval/wigets/bloc/submit_wooo_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/woo_approval/wigets/wooo_application_approval_widget.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class WoooApprovalDetailsPage extends StatefulWidget {
  final WoooDataEntities wooodataHistory;
  final bool isEditable;
  const WoooApprovalDetailsPage({
    super.key,
    required this.isEditable,
    required this.wooodataHistory,
  });

  @override
  State<WoooApprovalDetailsPage> createState() =>
      _WoooApprovalDetailsPageState();
}

class _WoooApprovalDetailsPageState extends State<WoooApprovalDetailsPage>
    with TickerProviderStateMixin {
  int _activeTabIndex = 0;

  String selectedId = '';
  late TabController _tabController;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? rejoiningDate;
  final TextEditingController totalHoursController = TextEditingController();
  final TextEditingController totalDaysController = TextEditingController();
  final TextEditingController selectedWoooType = TextEditingController();
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

    _activeTabIndex = _tabController.index;

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeTabIndex = _tabController.index;
          _updateTotalHoursOrDays();
        });
      }
    });

    final history = widget.wooodataHistory;

    totalDaysController.text = history.totalDays.toString();
    selectedWoooType.text = history.woooType;
    fromDate = _parseDate(history.fromDate);
    toDate = _parseDate(history.toDate);
    rejoiningDate = _parseDate(history.rejoiningDate);
    reasonController.text = history.reason;
  }

  @override
  void _updateTotalHoursOrDays() {
    if (fromDate != null && toDate != null) {
      if (_activeTabIndex == 0) {
        // For Hours tab
        final diff = toDate!.difference(fromDate!);
        final totalHours = diff.inMinutes / 60.0;
        totalHoursController.text = totalHours.toStringAsFixed(1);
      } else {
        // For Days tab
        final diff = toDate!.difference(fromDate!).inDays + 1;
        totalDaysController.text = diff.toString();
      }

      rejoiningDate = toDate!.add(const Duration(days: 1));
    } else {
      totalHoursController.clear();
      totalDaysController.clear();
      rejoiningDate = null;
    }
  }

  final List<Map<String, dynamic>> statusItems = [
    {"id": "1", "name": "Accepted"},
    {"id": "2", "name": "Rejected"},
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Locales.string(context, "woo_approval_details")),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: Locales.string(context, "for_hours")),
              Tab(text: Locales.string(context, "for_days")),
            ],
            labelColor: context.theme.colorScheme.onPrimary,
            indicatorColor: Colors.white,
          ),
        ),
        body: SafeArea(
          child: PageContainer(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      WoooApplicationApprovalWidget(
                        activeTabIndex: _activeTabIndex,
                        selectedWoooType: selectedWoooType,

                        fromDate:
                            fromDate ?? DateTime.now(), // optional fallback
                        toDate: toDate ?? DateTime.now(),
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
                        reasonController: reasonController,
                        rejoiningDate: rejoiningDate,
                        totalDaysController: totalDaysController,
                        totalHoursController: totalHoursController,
                        isEditable: widget.isEditable,
                        status: statusItems,
                        selectedId: selectedId,
                        onStatusChanged: (value) {
                          setState(() {
                            selectedId = value;
                          });
                        },
                      ),

                      WoooApplicationApprovalWidget(
                        activeTabIndex: _activeTabIndex,
                        selectedWoooType: selectedWoooType,
                        fromDate: fromDate ?? DateTime.now(),
                        toDate: toDate ?? DateTime.now(),
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
                        reasonController: reasonController,
                        rejoiningDate: rejoiningDate,
                        totalDaysController: totalDaysController,
                        totalHoursController: totalHoursController,
                        isEditable: widget.isEditable,
                        status: statusItems,
                        selectedId: selectedId,
                        onStatusChanged: (value) {
                          setState(() {
                            selectedId = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (widget.isEditable)
                  BlocListener<SubmitWoooApprovalBloc, SubmitWoooApprovalState>(
                    listener: (context, state) {
                      if (state is SubmitWoooApprovalError) {
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
                      if (state is SubmitWoooApprovalSuccess) {
                        final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: Locales.string(context, "success"),
                            message: Locales.string(
                              context,
                              "wooo_application_submitted",
                            ),
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
                        context.read<SubmitWoooApprovalBloc>().add(
                          SubmitWoooApplicationEvent(
                            status: selectedId,
                            employeeWoooId:
                                widget.wooodataHistory.employeeWoooId
                                    .toString(),
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
