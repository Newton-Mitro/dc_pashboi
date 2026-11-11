import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/loan_policies/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/loan_policies/domain/usecases/fetch_loan_policy_usecase.dart';

class _MockProductApiService extends Mock implements ProductApiService {}

Response<dynamic> _response({
  int statusCode = HttpStatus.ok,
  dynamic data,
  String path = '',
}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: path),
    statusCode: statusCode,
    data: data,
  );
}

void main() {
  late _MockProductApiService apiService;
  late LoanPolicyRemoteDataSourceImpl dataSource;
  final props = FetchLoanPolicyProps(categoryId: 'category-1');
  final expectedPath = '${ApiUrls.getDepositPolicies}/category-1';

  setUp(() {
    apiService = _MockProductApiService();
    dataSource = LoanPolicyRemoteDataSourceImpl(productApiService: apiService);
  });

  test('fetches policies by category and parses the Product list', () async {
    when(() => apiService.get(expectedPath)).thenAnswer(
      (_) async => _response(
        path: expectedPath,
        data: {
          'Product': [
            {
              'id': 'policy-1',
              'title': 'Personal Loan',
              'order': 3,
              'long_description': 'Full policy',
              'product_categories_id': 'category-1',
              'created_at': '2025-01-01T10:00:00.000Z',
              'updated_at': '2025-01-02T10:00:00.000Z',
            },
          ],
        },
      ),
    );

    final policies = await dataSource.fetchLoanPoliciesByCategoryId(props);

    expect(policies, hasLength(1));
    expect(policies.single.id, 'policy-1');
    expect(policies.single.categoryId, 'category-1');
    expect(policies.single.longDescription, 'Full policy');
    verify(() => apiService.get(expectedPath)).called(1);
  });

  test('returns an empty list when the category has no policies', () async {
    when(() => apiService.get(expectedPath)).thenAnswer(
      (_) async => _response(path: expectedPath, data: {'Product': []}),
    );

    expect(await dataSource.fetchLoanPoliciesByCategoryId(props), isEmpty);
  });

  test('rejects a response without a Product list', () async {
    when(() => apiService.get(expectedPath)).thenAnswer(
      (_) async => _response(path: expectedPath, data: {'Product': null}),
    );

    expect(
      dataSource.fetchLoanPoliciesByCategoryId(props),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('expected a list'),
        ),
      ),
    );
  });

  test('rejects unsuccessful HTTP responses', () async {
    when(() => apiService.get(expectedPath)).thenAnswer(
      (_) async => _response(
        path: expectedPath,
        statusCode: HttpStatus.internalServerError,
      ),
    );

    expect(
      dataSource.fetchLoanPoliciesByCategoryId(props),
      throwsA(isA<Exception>()),
    );
  });
}
