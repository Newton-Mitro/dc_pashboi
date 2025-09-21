import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/entities/employee_details_entity.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/repositories/employee_details_repository.dart';

class EmployeeDetailsProps extends BaseRequestProps {
  const EmployeeDetailsProps({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class EmployeeDetailsUseCase
    extends UseCase<EmployeeDetailsEntity, EmployeeDetailsProps> {
  final EmployeeDetailsRepository employeeDetailsRepository;

  EmployeeDetailsUseCase({required this.employeeDetailsRepository});

  @override
  ResultFuture<EmployeeDetailsEntity> call(EmployeeDetailsProps props) async {
    return employeeDetailsRepository.getEmployeeDetails(props);
  }
}
