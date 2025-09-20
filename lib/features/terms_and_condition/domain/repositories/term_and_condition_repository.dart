import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/terms_and_condition/domain/usecases/fetch_term_and_condition_usecase.dart';

abstract class TermAndConditionRepository {
  ResultFuture<String> fetchTermAndCondition(FetchTermAndConditionProps props);
}
