import 'package:dartz/dartz.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';
import 'package:pashboi/features/terms_and_condition/data/datasources/term_and_condition_remote_datasource.dart';
import 'package:pashboi/features/terms_and_condition/domain/repositories/term_and_condition_repository.dart';
import 'package:pashboi/features/terms_and_condition/domain/usecases/fetch_term_and_condition_usecase.dart';

class TermAndConditionRepositoryImpl implements TermAndConditionRepository {
  final TermAndConditionRemoteDataSource termAndConditionRemoteDataSource;
  final NetworkInfo networkInfo;

  TermAndConditionRepositoryImpl({
    required this.termAndConditionRemoteDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<String> fetchTermAndCondition(
    FetchTermAndConditionProps props,
  ) async {
    try {
      final result = await termAndConditionRemoteDataSource
          .fetchTermAndCondition(props);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
