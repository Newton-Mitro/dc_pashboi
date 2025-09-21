import 'package:equatable/equatable.dart';

sealed class AttendanceCalenderEvent extends Equatable {
  const AttendanceCalenderEvent();

  @override
  List<Object> get props => [];
}

class AttendanceCalenderHistory extends AttendanceCalenderEvent {
  final String fromDate;
  final String toDate;

  const AttendanceCalenderHistory({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object> get props => [fromDate, toDate];
}
