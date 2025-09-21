import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/search_employee_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';

class SearchEmployee extends BaseRequestProps {
  final String searchText;

  const SearchEmployee({
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.searchText,
  });
}

class SearchEmployeeUseCase
    extends UseCase<List<SearchEmployeeEntity>, SearchEmployee> {
  final LeaveRepository leaveRepository;

  SearchEmployeeUseCase({required this.leaveRepository});

  @override
  ResultFuture<List<SearchEmployeeEntity>> call(SearchEmployee props) async {
    return leaveRepository.getSearchEmployee(props);
  }
}
