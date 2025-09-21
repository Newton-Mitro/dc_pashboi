import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class LeaveHistoryRequestProps extends BaseRequestProps {
  final DateTime toDate;
  final DateTime fromDate;

  const LeaveHistoryRequestProps({
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

class LeaveHistoryRequestUseCase
    extends UseCase<List<LeaveApplicationEntities>, LeaveHistoryRequestProps> {
  final LeaveRepository leaveRepository;

  LeaveHistoryRequestUseCase({required this.leaveRepository});

  @override
  ResultFuture<List<LeaveApplicationEntities>> call(
    LeaveHistoryRequestProps props,
  ) async {
    return leaveRepository.getLeaveHistory(props);
  }
}
