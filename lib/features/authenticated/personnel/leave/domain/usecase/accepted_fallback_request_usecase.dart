import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class AcceptedFallbackRequestParams extends BaseRequestProps {
  final String remarks;
  final int leaveApplicationId;

  const AcceptedFallbackRequestParams({
    required this.remarks,
    required this.leaveApplicationId,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class AcceptedFallbackUseCase
    extends UseCase<String, AcceptedFallbackRequestParams> {
  final LeaveRepository leaveRepository;

  AcceptedFallbackUseCase({required this.leaveRepository});

  @override
  ResultFuture<String> call(AcceptedFallbackRequestParams props) async {
    return leaveRepository.getAcceptedFallbackRequest(props);
  }
}
