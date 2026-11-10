import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/fetch_remote_result.dart';
import 'package:pashboi/features/public/deposit_policies/data/models/deposit_policy_model.dart';
import 'package:pashboi/features/public/deposit_policies/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/deposit_policies/domain/enities/deposit_policy_entity.dart';
import 'package:pashboi/features/public/deposit_policies/domain/repositories/deposit_policy_repository.dart';
import 'package:pashboi/features/public/deposit_policies/domain/usecases/fetch_deposit_policy_usecase.dart';

class DepositPolicyRepositoryImpl implements DepositPolicyRepository {
  final DepositPolicyRemoteDataSource depositPolicyRemoteDataSource;

  DepositPolicyRepositoryImpl({
    required this.depositPolicyRemoteDataSource,
  });

  @override
  ResultFuture<List<DepositPolicyEntity>> findDepositPoliciesByCategoryId(
    FetchPageProps props,
  ) async {
    return fetchRemoteResult<
      List<DepositPolicyModel>,
      List<DepositPolicyEntity>
    >(
      () => depositPolicyRemoteDataSource.fetchDepositPoliciesByCategoryId(
        props,
      ),
    );
  }
}
