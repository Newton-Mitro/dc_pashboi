import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';

class UpdateWoooProps extends BaseRequestProps {
  final String fromDate;
  final String toDate;
  final String rejoiningDate;
  final String reason;
  final String woooTypeCode;
  final bool isHourly;
  final int leaveApplicationId;
  const UpdateWoooProps({
    required this.fromDate,
    required this.toDate,
    required this.rejoiningDate,
    required this.reason,
    required this.woooTypeCode,
    required this.isHourly,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.leaveApplicationId,
  });
}

class UpdateWoooUseCase extends UseCase<String, UpdateWoooProps> {
  final WoooRepositories woooRepositories;

  UpdateWoooUseCase({required this.woooRepositories});

  @override
  ResultFuture<String> call(UpdateWoooProps props) async {
    return woooRepositories.updateWoooRequest(props);
  }
}
