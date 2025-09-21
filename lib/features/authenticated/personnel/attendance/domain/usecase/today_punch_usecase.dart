import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/today_punch_entity.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/repositories/attendance_repository_interface.dart';

class TodayPunchProps extends BaseRequestProps {
  final String fromDate;
  final String toDate;

  const TodayPunchProps({
    required this.fromDate,
    required this.toDate,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class TodayPunchUseCase
    extends UseCase<List<TodayPunchEntity>, TodayPunchProps> {
  final AttendanceRepositoryInterface repositoryInterface;

  TodayPunchUseCase({required this.repositoryInterface});

  @override
  ResultFuture<List<TodayPunchEntity>> call(TodayPunchProps props) async {
    return repositoryInterface.todayPaunch(props);
  }
}
