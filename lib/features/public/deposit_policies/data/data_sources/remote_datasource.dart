import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/deposit_policies/data/models/deposit_policy_model.dart';
import 'package:pashboi/features/public/deposit_policies/domain/usecases/fetch_deposit_policy_usecase.dart';

abstract class DepositPolicyRemoteDataSource {
  Future<List<DepositPolicyModel>> fetchDepositPoliciesByCategoryId(
    FetchPageProps props,
  );
}

class DepositPolicyRemoteDataSourceImpl
    implements DepositPolicyRemoteDataSource {
  final ProductApiService productApiService;

  DepositPolicyRemoteDataSourceImpl({required this.productApiService});

  @override
  Future<List<DepositPolicyModel>> fetchDepositPoliciesByCategoryId(
    FetchPageProps props,
  ) async {
    try {
      final response = await productApiService.get(
        "${ApiUrls.getDepositPolicies}/${props.categoryId}",
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data?['Product']; // already a List<dynamic>

        if (data == null || data is! List) {
          throw Exception('Invalid response format: expected a list');
        }

        final List<DepositPolicyModel> depositPolicies =
            data.map((json) => DepositPolicyModel.fromJson(json)).toList();

        return depositPolicies;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
