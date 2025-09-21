import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';

class SubmitWoooApplicationPropsProps extends BaseRequestProps {
  final String fromDate;
  final String toDate;
  final String rejoiningDate;
  final String reason;
  final String woooTypeCode;
  final bool isHourly;

  const SubmitWoooApplicationPropsProps({
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
  });
}

class SubmitWoooApplicationUseCase
    extends UseCase<String, SubmitWoooApplicationPropsProps> {
  final WoooRepositories woooRepositories;

  SubmitWoooApplicationUseCase({required this.woooRepositories});

  @override
  ResultFuture<String> call(SubmitWoooApplicationPropsProps props) async {
    return woooRepositories.submitWoooApplication(props);
  }
}
