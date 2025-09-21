import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/repositories/attendance_repository_interface.dart';

class AttendanceProps extends BaseRequestProps {
  final String fromDate;
  final String toDate;

  const AttendanceProps({
    required this.toDate,
    required this.fromDate,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class AttendanceUseCase
    extends UseCase<List<GetAttendanceEntities>, AttendanceProps> {
  final AttendanceRepositoryInterface attendanceRepository;

  AttendanceUseCase({required this.attendanceRepository});

  @override
  ResultFuture<List<GetAttendanceEntities>> call(AttendanceProps props) async {
    return attendanceRepository.getAttendance(props);
  }
}
