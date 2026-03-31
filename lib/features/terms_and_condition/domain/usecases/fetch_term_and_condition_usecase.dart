import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/terms_and_condition/domain/repositories/term_and_condition_repository.dart';

class FetchTermAndConditionProps {
  final String contentName;

  const FetchTermAndConditionProps({required this.contentName});
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
