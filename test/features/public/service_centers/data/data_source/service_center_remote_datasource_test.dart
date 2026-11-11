import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/service_centers/data/data_source/remort_service_center_datasource.dart';

class _MockProductApiService extends Mock implements ProductApiService {}

Response<dynamic> _response({int statusCode = HttpStatus.ok, dynamic data}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ApiUrls.getAllBranch),
    statusCode: statusCode,
    data: data,
  );
}

void main() {
  late _MockProductApiService apiService;
  late ServiceCenterRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockProductApiService();
    dataSource = ServiceCenterRemoteDataSourceImpl(
      productApiService: apiService,
    );
  });

  test('requests all branches and parses the returned list', () async {
    when(() => apiService.get(ApiUrls.getAllBranch)).thenAnswer(
      (_) async => _response(
        data: [
          {
            'id': 'branch-1',
            'name': 'Central Branch',
            'created_at': '2025-01-01T10:00:00.000Z',
            'updated_at': '2025-01-02T10:00:00.000Z',
          },
        ],
      ),
    );

    final branches = await dataSource.findAllServiceCenters();

    expect(branches, hasLength(1));
    expect(branches.single.id, 'branch-1');
    expect(branches.single.name, 'Central Branch');
    verify(() => apiService.get(ApiUrls.getAllBranch)).called(1);
  });

  test('returns an empty list when there are no branches', () async {
    when(
      () => apiService.get(ApiUrls.getAllBranch),
    ).thenAnswer((_) async => _response(data: []));

    expect(await dataSource.findAllServiceCenters(), isEmpty);
  });

  test('rejects a response that is not a list', () async {
    when(
      () => apiService.get(ApiUrls.getAllBranch),
    ).thenAnswer((_) async => _response(data: {'branches': []}));

    expect(
      dataSource.findAllServiceCenters(),
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
    when(() => apiService.get(ApiUrls.getAllBranch)).thenAnswer(
      (_) async => _response(statusCode: HttpStatus.internalServerError),
    );

    expect(dataSource.findAllServiceCenters(), throwsA(isA<Exception>()));
  });
}
