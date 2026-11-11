import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/project/data/data_source/project_remote_data_source.dart';

class _MockProductApiService extends Mock implements ProductApiService {}

Response<dynamic> _response({int statusCode = HttpStatus.ok, dynamic data}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ApiUrls.getProject),
    statusCode: statusCode,
    data: data,
  );
}

void main() {
  late _MockProductApiService apiService;
  late ProjectRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockProductApiService();
    dataSource = ProjectRemoteDataSourceImpl(productApiService: apiService);
  });

  test('requests projects and parses the Project response list', () async {
    when(() => apiService.get(ApiUrls.getProject)).thenAnswer(
      (_) async => _response(
        data: {
          'Project': [
            {
              'id': 'project-1',
              'title': 'Community Center',
              'order': 4,
              'description': 'A space for local programs',
              'created_at': '2025-01-01T10:00:00.000Z',
              'updated_at': '2025-01-02T10:00:00.000Z',
            },
          ],
        },
      ),
    );

    final projects = await dataSource.findProject();

    expect(projects, hasLength(1));
    expect(projects.single.id, 'project-1');
    expect(projects.single.longDescription, 'A space for local programs');
    verify(() => apiService.get(ApiUrls.getProject)).called(1);
  });

  test('returns an empty list when the API returns no projects', () async {
    when(
      () => apiService.get(ApiUrls.getProject),
    ).thenAnswer((_) async => _response(data: {'Project': []}));

    expect(await dataSource.findProject(), isEmpty);
  });

  test('rejects a response without a project list', () async {
    when(
      () => apiService.get(ApiUrls.getProject),
    ).thenAnswer((_) async => _response(data: {'Project': null}));

    expect(
      dataSource.findProject(),
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
    when(() => apiService.get(ApiUrls.getProject)).thenAnswer(
      (_) async => _response(statusCode: HttpStatus.internalServerError),
    );

    expect(dataSource.findProject(), throwsA(isA<Exception>()));
  });
}
