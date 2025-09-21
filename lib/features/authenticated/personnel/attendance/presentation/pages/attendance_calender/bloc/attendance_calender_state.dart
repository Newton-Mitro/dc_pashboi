part of 'attendance_calender_bloc.dart';

sealed class AttendanceCalenderState extends Equatable {
  const AttendanceCalenderState();

  @override
  List<Object> get props => [];
}

final class AttendanceCalenderInitial extends AttendanceCalenderState {
  const AttendanceCalenderInitial();
}

final class AttendanceCalenderLoading extends AttendanceCalenderState {
  const AttendanceCalenderLoading();
}

final class AttendanceCalenderSuccess extends AttendanceCalenderState {
  final List<GetAttendanceEntities> attendanceEntities;

  const AttendanceCalenderSuccess(this.attendanceEntities);

  @override
  List<Object> get props => [attendanceEntities];
}

final class AttendanceCalenderError extends AttendanceCalenderState {
  final String message;

  const AttendanceCalenderError(this.message);

  @override
  List<Object> get props => [message];
}
