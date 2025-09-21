import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class SubmitLeaveApprovalProps extends BaseRequestProps {
  final String leaveStageRemarks;
  final int leaveApplicationId;

  const SubmitLeaveApprovalProps({
    required this.leaveStageRemarks,
    required this.leaveApplicationId,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class SubmitLeaveApprovalUseCase
    extends UseCase<String, SubmitLeaveApprovalProps> {
  final LeaveRepository leaveRepository;

  SubmitLeaveApprovalUseCase({required this.leaveRepository});

  @override
  ResultFuture<String> call(SubmitLeaveApprovalProps props) async {
    return leaveRepository.submitLeaveApproval(props);
  }
}
