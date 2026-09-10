import 'dart:io';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/loan_policies/data/models/loan_policy_model.dart';
import 'package:pashboi/features/public/loan_policies/domain/usecases/fetch_loan_policy_usecase.dart';

abstract class LoanPolicyRemoteDataSource {
  Future<List<LoanPolicyModel>> fetchLoanPoliciesByCategoryId(
    FetchLoanPolicyProps props,
  );
}

class LoanPolicyRemoteDataSourceImpl implements LoanPolicyRemoteDataSource {
  final ProductApiService productApiService;

  LoanPolicyRemoteDataSourceImpl({required this.productApiService});

  @override
  Future<List<LoanPolicyModel>> fetchLoanPoliciesByCategoryId(
    FetchLoanPolicyProps props,
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

        final List<LoanPolicyModel> loanPolicies =
            data.map((json) => LoanPolicyModel.fromJson(json)).toList();

        return loanPolicies;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
