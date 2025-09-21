import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';

class WoooApprovalSubmitUseCaseProps extends BaseRequestProps {
  final String employeeWoooId;
  final String status;
  const WoooApprovalSubmitUseCaseProps({
    required this.employeeWoooId,
    required this.status,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class WoooApprovalSubmitUseCase
    extends UseCase<String, WoooApprovalSubmitUseCaseProps> {
  final WoooRepositories woooRepositories;

  WoooApprovalSubmitUseCase({required this.woooRepositories});

  @override
  ResultFuture<String> call(WoooApprovalSubmitUseCaseProps props) async {
    return woooRepositories.submitWoooApprovalRequest(props);
  }
}
