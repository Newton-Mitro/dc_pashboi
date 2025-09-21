import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/bloc/wooo_type_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/widget/bloc/submit_wooo_application_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/widget/wooo_application_widget.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class WoooApplicationPage extends StatefulWidget {
  const WoooApplicationPage({super.key});

  @override
  State<WoooApplicationPage> createState() => _WoooApplicationPageState();
}

class _WoooApplicationPageState extends State<WoooApplicationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeTabIndex = 0;
  String? selectedWoooType;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? rejoiningDate;
  final TextEditingController totalHoursController = TextEditingController();
  final TextEditingController totalDaysController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _activeTabIndex = _tabController.index;
          _updateTotalHoursOrDays(); // Recalculate when switching tabs
        });
      }
    });

    context.read<WoooTypeBloc>().add(FetchWoooTypeEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    totalHoursController.dispose();
    totalDaysController.dispose();
    reasonController.dispose();
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
                          // For Hours
                          WoooApplicationWidget(
                            activeTabIndex: 0,
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

                          // For Days
                          WoooApplicationWidget(
                            activeTabIndex: 1,
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

              const SizedBox(height: 5),

              BlocListener<
                SubmitWoooApplicationBloc,
                SubmitWoooApplicationState
              >(
                listener: (context, state) {
                  if (state is SubmitWoooApplicationError) {
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

                  if (state is SubmitWoooApplicationSuccess) {
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Done!',
                        message:
                            "Working Out of Office application apply successfully",
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
                    context.read<SubmitWoooApplicationBloc>().add(
                      SubmitWoooApplication(
                        fromDate: fromDate.toString(),
                        toDate: toDate.toString(),
                        rejoiningDate: rejoiningDate.toString(),
                        reason: reasonController.text,
                        woooTypeCode: selectedWoooType!,
                        isHourly: _activeTabIndex == 0 ? true : false,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
