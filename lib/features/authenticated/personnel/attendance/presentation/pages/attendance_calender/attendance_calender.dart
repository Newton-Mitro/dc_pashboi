import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Calendar")),
      body: BlocListener<AttendanceCalenderBloc, AttendanceCalenderState>(
        listener: (context, state) {
          if (state is AttendanceCalenderError) {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Oops!',
                message: state.message ?? "Something went wrong",
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
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AttendanceCalenderBloc, AttendanceCalenderState>(
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

                  return Column(
                    children: [
                      TableCalendar<AttendanceEvent>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2040, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate:
                            (day) => isSameDay(_selectedDay, day),
                        calendarFormat: _calendarFormat,
                        eventLoader: _getEventsForDay,
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
                            if (events.isEmpty) return const SizedBox();

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  events.map((event) {
                                    return Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _getMarkerColor(event.remarks),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        event.status ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ValueListenableBuilder<List<AttendanceEvent>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            if (value.isEmpty) {
                              return const Center(
                                child: Text('No attendance record'),
                              );
                            }
                            return ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                final event = value[index];
                                return ListTile(
                                  leading: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _getMarkerColor(event.remarks),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  title: Text('Status: ${event.remarks}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'In:  ${extractTime(event.punchIn)}',
                                      ),
                                      Text(
                                        'Out:  ${extractTime(event.punchOut)}',
                                      ),
                                      Text(
                                        'Punch Area: ${event.punchArea ?? "--"}',
                                      ),
                                      Text(
                                        'Branch: ${event.branchName ?? "--"}',
                                      ),
                                      Text('Remarks: ${event.remarks}'),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const Center(child: Text("No data available"));
              },
            ),
          ),
        ),
      ),
    );
  }
}
