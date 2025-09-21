import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_type_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class LeaveTypeProps extends BaseRequestProps {
  const LeaveTypeProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class LeaveTypeUseCase extends UseCase<List<LeaveTypeEntity>, LeaveTypeProps> {
  final LeaveRepository leaveRepository;

  LeaveTypeUseCase({required this.leaveRepository});

  @override
  ResultFuture<List<LeaveTypeEntity>> call(LeaveTypeProps props) async {
    return leaveRepository.getLeaveType(props);
  }
}
