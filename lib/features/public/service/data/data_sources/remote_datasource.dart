import 'dart:io';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/service/data/models/service_policy_model.dart';
import 'package:pashboi/features/public/service/domain/usecases/fetch_service_policy_usecase.dart';

abstract class ServicePolicyRemoteDataSource {
  Future<List<ServicePolicyModel>> fetchServicePoliciesByCategoryId(
    FetchServicePolicyProps props,
  );
}

class ServicePolicyRemoteDataSourceImpl
    implements ServicePolicyRemoteDataSource {
  final ProductApiService productApiService;

  ServicePolicyRemoteDataSourceImpl({required this.productApiService});

  @override
  Future<List<ServicePolicyModel>> fetchServicePoliciesByCategoryId(
    FetchServicePolicyProps props,
  ) async {
    try {
      final response = await productApiService.get(
        "${ApiUrls.getDepositPolicies}/${props.categoryId}",
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data?['Product'];

        if (data == null || data is! List) {
          throw Exception('Invalid response format: expected a list');
        }

        final List<ServicePolicyModel> servicePolicies =
            data.map((json) => ServicePolicyModel.fromJson(json)).toList();

        return servicePolicies;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
