import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';

class GetWoooApprovalProps extends BaseRequestProps {
  final DateTime fromDate;
  final DateTime toDate;

  const GetWoooApprovalProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.fromDate,
    required this.toDate,
  });
}

class GetWoooApprovalUsecase
    extends UseCase<List<WoooDataEntities>, GetWoooApprovalProps> {
  final WoooRepositories woooRepositories;

  GetWoooApprovalUsecase({required this.woooRepositories});

  @override
  ResultFuture<List<WoooDataEntities>> call(GetWoooApprovalProps props) async {
    return woooRepositories.getWoooApprovalData(props);
  }
}
