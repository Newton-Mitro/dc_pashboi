import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class SubmitLeaveApplicationProps extends BaseRequestProps {
  final String remarks;
  final String fallbackEmployeeCode;
  final String rejoiningDate;
  final String toDate;
  final String fromDate;
  final String leaveTypeCode;
  final String leaveStageRemarks;
  final String formTime;
  final String toTime;

  const SubmitLeaveApplicationProps({
    required this.remarks,
    required this.fallbackEmployeeCode,
    required this.rejoiningDate,
    required this.toDate,
    required this.fromDate,
    required this.leaveTypeCode,
    required this.leaveStageRemarks,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.formTime,
    required this.toTime,
  });
}

class SubmitLeaveApplicationUseCase
    extends UseCase<String, SubmitLeaveApplicationProps> {
  final LeaveRepository leaveRepository;

  SubmitLeaveApplicationUseCase({required this.leaveRepository});

  @override
  ResultFuture<String> call(SubmitLeaveApplicationProps props) async {
    return leaveRepository.submitLeaveApplication(props);
  }
}
