import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_type_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';

class WooTypeUseCaseProps extends BaseRequestProps {
  const WooTypeUseCaseProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class WoooTypeUseCase
    extends UseCase<List<WoooTypeEntities>, WooTypeUseCaseProps> {
  final WoooRepositories woooRepositories;

  WoooTypeUseCase({required this.woooRepositories});

  @override
  ResultFuture<List<WoooTypeEntities>> call(WooTypeUseCaseProps props) async {
    return woooRepositories.getWooType(props);
  }
}
