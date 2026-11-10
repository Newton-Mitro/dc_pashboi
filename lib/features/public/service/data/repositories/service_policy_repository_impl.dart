import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/fetch_remote_result.dart';
import 'package:pashboi/features/public/service/data/models/service_policy_model.dart';
import 'package:pashboi/features/public/service/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/service/domain/enities/service_policy_entity.dart';
import 'package:pashboi/features/public/service/domain/repositories/service_policy_repository.dart';
import 'package:pashboi/features/public/service/domain/usecases/fetch_service_policy_usecase.dart';

class ServicePolicyRepositoryImpl implements ServicePolicyRepository {
  final ServicePolicyRemoteDataSource servicePolicyRemoteDataSource;

  ServicePolicyRepositoryImpl({required this.servicePolicyRemoteDataSource});

  @override
  ResultFuture<List<ServicePolicyEntity>> findServicePoliciesByCategoryId(
    FetchServicePolicyProps props,
  ) async {
    return fetchRemoteResult<
      List<ServicePolicyModel>,
      List<ServicePolicyEntity>
    >(
      () => servicePolicyRemoteDataSource.fetchServicePoliciesByCategoryId(
        props,
      ),
    );
  }
}
