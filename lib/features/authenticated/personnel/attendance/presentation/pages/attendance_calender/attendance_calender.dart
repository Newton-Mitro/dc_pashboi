import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/attendance_calender/bloc/attendance_calender_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/attendance_calender/bloc/attendance_calender_event.dart';
import 'package:pashboi/shared/widgets/page_container.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatefulWidget {
  const AttendanceCalendar({super.key});

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

// Your AttendanceEvent model
class AttendanceEvent {
  final String? remarks;
  final String? punchIn;
  final String? punchOut;
  final String? attendanceDate;
  final String? branchName;
  final String? punchArea;
  final String? status;

  AttendanceEvent({
    required this.remarks,
    this.punchIn,
    this.punchOut,
    this.attendanceDate,
    this.branchName,
    this.punchArea,
    this.status,
  });

  // Factory constructor to convert from GetAttendanceEntities
  factory AttendanceEvent.fromEntity(GetAttendanceEntities e) {
    return AttendanceEvent(
      remarks: e.remarks,
      punchIn: e.punchIn,
      punchOut: e.punchOut,
      attendanceDate: e.attendanceDate,
      branchName: e.branchName,
      punchArea: e.punchArea,
      status: e.status,
    );
  }
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  late final ValueNotifier<List<AttendanceEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late final Map<DateTime, List<AttendanceEvent>> _attendanceEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _attendanceEvents = {};
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _sendAttendanceHistoryForMonth(_focusedDay);
  }

  void _sendAttendanceHistoryForMonth(DateTime focusedDay) {
    final fromDate = DateTime(focusedDay.year, focusedDay.month, 1);
    final toDate = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    context.read<AttendanceCalenderBloc>().add(
      AttendanceCalenderHistory(
        fromDate: fromDate.toIso8601String(),
        toDate: toDate.toIso8601String(),
      ),
    );
  }

  List<AttendanceEvent> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _attendanceEvents[key] ?? [];
  }

  String extractTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return "--";
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat.jm().format(dateTime); // returns "09:44"
      // Or use: return DateFormat.Hms().format(dateTime); // returns "09:44:10"
    } catch (e) {
      return "--";
    }
  }

  void _updateAttendanceEvents(List<AttendanceEvent> events) {
    _attendanceEvents.clear();

    for (var event in events) {
      if (event.attendanceDate == null) continue;

      final date = DateTime.tryParse(event.attendanceDate!);
      if (date == null) continue;

      final key = DateTime(date.year, date.month, date.day);

      if (_attendanceEvents.containsKey(key)) {
        _attendanceEvents[key]!.add(event);
      } else {
        _attendanceEvents[key] = [event];
      }
    }

    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  Color _getMarkerColor(String? remarks) {
    switch (remarks?.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'leave':
        return Colors.orange;
      case 'holiday':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAttendanceCard(BuildContext context, AttendanceEvent event) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final statusColor = _getMarkerColor(event.remarks);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.event_available_rounded,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${Locales.string(context, "status")}: ${event.remarks ?? "--"}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (event.status != null && event.status!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.status!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPunchTime(
                    context,
                    label: Locales.string(context, "punch_in"),
                    time: extractTime(event.punchIn),
                    icon: Icons.login_rounded,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPunchTime(
                    context,
                    label: Locales.string(context, "punch_out"),
                    time: extractTime(event.punchOut),
                    icon: Icons.logout_rounded,
                    color: colors.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: colors.outlineVariant, height: 1),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              icon: Icons.location_on_outlined,
              label: Locales.string(context, "punch_area"),
              value: event.punchArea,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              context,
              icon: Icons.account_balance_outlined,
              label: Locales.string(context, "branch"),
              value: event.branchName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPunchTime(
    BuildContext context, {
    required String label,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value == null || value.isEmpty ? "--" : value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, "attendance_calendar")),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        child: BlocListener<AttendanceCalenderBloc, AttendanceCalenderState>(
          listener: (context, state) {
            if (state is AttendanceCalenderError) {
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
          },
          child: PageContainer(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: BlocBuilder<
                AttendanceCalenderBloc,
                AttendanceCalenderState
              >(
                builder: (context, state) {
                  if (state is AttendanceCalenderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AttendanceCalenderSuccess) {
                    // Map GetAttendanceEntities to AttendanceEvent and update events
                    final attendanceEvents =
                        state.attendanceEntities
                            .map((e) => AttendanceEvent.fromEntity(e))
                            .toList();

                    _updateAttendanceEvents(attendanceEvents);

                    final theme = Theme.of(context);
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            color: theme.colorScheme.surface,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                              child: TableCalendar<AttendanceEvent>(
                                firstDay: DateTime.utc(2020, 1, 1),
                                lastDay: DateTime.utc(2040, 12, 31),
                                focusedDay: _focusedDay,
                                selectedDayPredicate:
                                    (day) => isSameDay(_selectedDay, day),
                                calendarFormat: _calendarFormat,
                                eventLoader: _getEventsForDay,
                                rowHeight: 48,
                                daysOfWeekHeight: 36,
                                headerStyle: HeaderStyle(
                                  titleCentered: true,
                                  formatButtonDecoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  formatButtonTextStyle: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  leftChevronIcon: Icon(
                                    Icons.chevron_left_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.chevron_right_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                daysOfWeekStyle: DaysOfWeekStyle(
                                  weekdayStyle: theme.textTheme.labelMedium!
                                      .copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  weekendStyle: theme.textTheme.labelMedium!
                                      .copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                calendarStyle: CalendarStyle(
                                  outsideDaysVisible: false,
                                  defaultDecoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  weekendDecoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  selectedTextStyle: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  todayTextStyle: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  markersAlignment: Alignment.bottomCenter,
                                  markersMaxCount: 3,
                                  markerSize: 5,
                                  markerMargin: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                ),
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    _selectedEvents.value = _getEventsForDay(
                                      selectedDay,
                                    );
                                  });
                                },
                                onFormatChanged: (format) {
                                  setState(() => _calendarFormat = format);
                                },
                                onPageChanged: (focusedDay) {
                                  setState(() {
                                    _focusedDay = focusedDay;
                                  });

                                  _sendAttendanceHistoryForMonth(focusedDay);
                                },
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, date, events) {
                                    if (events.isEmpty) {
                                      return const SizedBox.shrink();
                                    }

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          events.take(3).map((event) {
                                            return Container(
                                              width: 5,
                                              height: 5,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 1,
                                                  ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _getMarkerColor(
                                                  event.remarks,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder<List<AttendanceEvent>>(
                            valueListenable: _selectedEvents,
                            builder: (context, value, _) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_selectedDay != null)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        4,
                                        0,
                                        4,
                                        12,
                                      ),
                                      child: Text(
                                        DateFormat.yMMMMEEEEd().format(
                                          _selectedDay!,
                                        ),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  if (value.isEmpty)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 28,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color:
                                              theme.colorScheme.outlineVariant,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.event_busy_rounded,
                                            size: 34,
                                            color:
                                                theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            Locales.string(
                                              context,
                                              "no_record_selected",
                                            ),
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      theme
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    ...value.map(
                                      (event) =>
                                          _buildAttendanceCard(context, event),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: Text(Locales.string(context, "no_data_available")),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
