import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/core/utils/my_date_utils.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_history/bloc/get_wooo_data_bloc.dart';
import 'package:pashboi/features/my_app/presentation/pages/my_app.dart';
import 'package:pashboi/routes/auth_routes_name.dart';
import 'package:pashboi/shared/widgets/app_date_picker.dart';
import 'package:pashboi/shared/widgets/buttons/app_primary_button.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class WoooHistoryPage extends StatefulWidget {
  const WoooHistoryPage({super.key});

  @override
  State<WoooHistoryPage> createState() => _WoooHistoryPageState();
}

class _WoooHistoryPageState extends State<WoooHistoryPage> with RouteAware {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
    _fetchWoooHistory();
  }

  void _fetchWoooHistory() {
    if (_startDate != null && _endDate != null) {
      context.read<GetWoooDataBloc>().add(
        FetchWoooDataEvent(fromDate: _startDate!, toDate: _endDate!),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route observer
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // Unsubscribe from route observer
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this screen
    _fetchWoooHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "working_out_of_office_history")),
      ),
      body: PageContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: AppDatePicker(
                          selectedDate: _startDate,
                          onDateChanged: (d) => setState(() => _startDate = d),
                          label: Locales.string(context, "start_date"),
                          errorText: '',
                          firstDate: null,
                          enabled: true,
                        ),
                      ),
                      Expanded(
                        child: AppDatePicker(
                          selectedDate: _endDate,
                          onDateChanged: (d) => setState(() => _endDate = d),
                          label: Locales.string(context, "end_date"),
                          errorText: '',
                          firstDate: null,
                          enabled: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppPrimaryButton(
                    label: Locales.string(context, "search"),
                    onPressed: _fetchWoooHistory,
                  ),
                ],
              ),
            ),

            // List area
            Expanded(
              child: BlocBuilder<GetWoooDataBloc, GetWoooDataState>(
                builder: (context, state) {
                  if (state is GetWoooDataLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is GetWoooDataError) {
                    return Center(
                      child: Text(
                        'An error occurred',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (state is GetWoooDataSuccess) {
                    final requestList = state.WoooData;
                    if (requestList.isEmpty) {
                      return Center(
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
                              Locales.string(
                                context,
                                "no_working_out_of_office_info",
                              ),
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2.5,
                          ),
                          child: Card(
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
                                                request.woooType,
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
                                                      .woooDataHistoryDetailsPage,
                                                  arguments: {
                                                    'wooodataHistory': request,
                                                    'isEditable': false,
                                                  },
                                                );
                                              },
                                            ),

                                            if (request.isEditable)
                                              IconButton(
                                                icon: const Icon(
                                                  FontAwesomeIcons.edit,
                                                  size: 15,
                                                ),
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onPrimary,
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    AuthRoutesName
                                                        .woooDataHistoryDetailsPage,
                                                    arguments: {
                                                      'wooodataHistory':
                                                          request,
                                                      'isEditable': true,
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
                          ),
                        );
                      },
                    );
                  }

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
