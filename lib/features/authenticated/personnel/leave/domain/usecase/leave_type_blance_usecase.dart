import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class LeaveTypeBalanceProps extends BaseRequestProps {
  final String leaveTypeCode;

  const LeaveTypeBalanceProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.leaveTypeCode,
  });
}

class LeaveTypeBalanceUseCase
    extends UseCase<LeaveTypeBalanceDto, LeaveTypeBalanceProps> {
  final LeaveRepository leaveRepository;

  LeaveTypeBalanceUseCase({required this.leaveRepository});

  @override
  ResultFuture<LeaveTypeBalanceDto> call(LeaveTypeBalanceProps props) async {
    return leaveRepository.getLeaveTypeBalance(props);
  }
}
