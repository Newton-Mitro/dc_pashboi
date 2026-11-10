import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/fetch_remote_result.dart';
import 'package:pashboi/features/public/loan_policies/data/models/loan_policy_model.dart';
import 'package:pashboi/features/public/loan_policies/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/loan_policies/domain/entites/loan_policy_entity.dart';
import 'package:pashboi/features/public/loan_policies/domain/repositories/loan_policy_repository.dart';
import 'package:pashboi/features/public/loan_policies/domain/usecases/fetch_loan_policy_usecase.dart';

class LoanPolicyRepositoryImpl implements LoanPolicyRepository {
  final LoanPolicyRemoteDataSource loanPolicyRemoteDataSource;

  LoanPolicyRepositoryImpl({required this.loanPolicyRemoteDataSource});

  @override
  ResultFuture<List<LoanPolicyEntity>> findLoanPoliciesByCategoryId(
    FetchLoanPolicyProps props,
  ) async {
    return fetchRemoteResult<List<LoanPolicyModel>, List<LoanPolicyEntity>>(
      () => loanPolicyRemoteDataSource.fetchLoanPoliciesByCategoryId(props),
    );
  }
}
