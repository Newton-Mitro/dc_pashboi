import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/terms_and_condition/domain/repositories/term_and_condition_repository.dart';

class FetchTermAndConditionProps extends BaseRequestProps {
  final String contentName;

  const FetchTermAndConditionProps({
    required this.contentName,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class FetchTermAndConditionUseCase
    extends UseCase<String, FetchTermAndConditionProps> {
  final TermAndConditionRepository termAndConditionRepository;

  FetchTermAndConditionUseCase({required this.termAndConditionRepository});

  @override
  ResultFuture<String> call(FetchTermAndConditionProps props) async {
    return termAndConditionRepository.fetchTermAndCondition(props);
  }
}
