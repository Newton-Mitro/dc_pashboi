import 'package:dartz/dartz.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/today_punch_entity.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/repositories/attendance_repository_interface.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';

class AttendanceRepositoryInterfaceImpl
    implements AttendanceRepositoryInterface {
  final AttendanceRemoteDataSource attendanceRemoteDataSource;
  final NetworkInfo networkInfo;

  AttendanceRepositoryInterfaceImpl({
    required this.attendanceRemoteDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<List<GetAttendanceEntities>> getAttendance(
    AttendanceProps params,
  ) async {
    try {
      final result = await attendanceRemoteDataSource.fetchAttendance(params);

      final fallbackApplications =
          result.map((e) => e as GetAttendanceEntities).toList();

      return Right(fallbackApplications);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<TodayPunchEntity>> todayPaunch(
    TodayPunchProps params,
  ) async {
    try {
      final result = await attendanceRemoteDataSource.fetchPaunch(params);

      final fallbackApplications =
          result.map((e) => e as TodayPunchEntity).toList();

      return Right(fallbackApplications);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
