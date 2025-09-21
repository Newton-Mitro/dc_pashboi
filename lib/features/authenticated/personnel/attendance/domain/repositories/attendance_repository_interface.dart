import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/today_punch_entity.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';

abstract class AttendanceRepositoryInterface {
  ResultFuture<List<GetAttendanceEntities>> getAttendance(
    AttendanceProps props,
  );

  ResultFuture<List<TodayPunchEntity>> todayPaunch(TodayPunchProps props);
}
