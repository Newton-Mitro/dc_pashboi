import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/todays_punch/bloc/today_punch_bloc.dart';
import 'package:pashboi/shared/widgets/page_container.dart';

class TodaysPunch extends StatefulWidget {
  const TodaysPunch({super.key});

  @override
  State<TodaysPunch> createState() => _TodaysPunchState();
}

class _TodaysPunchState extends State<TodaysPunch> {
  String extractTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.trim().isEmpty) {
      return "--";
    }
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return "--";
    }
  }

  @override
  void initState() {
    super.initState();
    // Dispatch the event to load today's punch data
    context.read<TodayPunchBloc>().add(
      TodayPunchHistory(
        fromDate: DateTime.now().toIso8601String(),
        toDate: DateTime.now().toIso8601String(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Locales.string(context, "todays_punch"))),
      body: SafeArea(
        child: PageContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TodayPunchBloc, TodayPunchState>(
              builder: (context, state) {
                if (state is TodayPunchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TodayPunchError) {
                  return Text(
                    state.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  );
                }

                if (state is TodayPunchSuccess) {
                  final todayPunchEntities = state.todayPunchEntities;

                  if (todayPunchEntities.isEmpty) {
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
                            Locales.string(context, "no_record_found"),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  final punches = todayPunchEntities;
                  return SingleChildScrollView(
                    child: Column(
                      children:
                          punches.map((punch) {
                            return Card(
                              color: context.theme.colorScheme.surface,
                              elevation: 3,
                              shadowColor: context.theme.colorScheme.shadow,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        // Left Icon Area
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  context
                                                      .theme
                                                      .colorScheme
                                                      .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft: Radius.circular(
                                                      4,
                                                    ),
                                                  ),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                FontAwesomeIcons.mapLocation,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Right Detail Area
                                        Expanded(
                                          flex: 7,
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
                                                  punch.punchArea,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  "${Locales.string(context, "punch_in")}: ${extractTime(punch.checkInTime)} ",
                                                ),
                                                const SizedBox(height: 4),

                                                Text(
                                                  "${Locales.string(context, "remarks")}: ${punch.remarks}",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  );
                }

                if (state is TodayPunchError) {
                  return Center(
                    child: Text(state.message ?? "Something went wrong."),
                  );
                }

                return const SizedBox(); // fallback UI
              },
            ),
          ),
        ),
      ),
    );
  }
}
