import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class FallbackRequestUseCaseProps extends BaseRequestProps {
  const FallbackRequestUseCaseProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FallbackRequestUseCase
    extends
        UseCase<List<LeaveApplicationEntities>, FallbackRequestUseCaseProps> {
  final LeaveRepository leaveRepository;

  FallbackRequestUseCase({required this.leaveRepository});

  @override
  ResultFuture<List<LeaveApplicationEntities>> call(
    FallbackRequestUseCaseProps props,
  ) async {
    return leaveRepository.getFallbackRequest(props);
  }
}
