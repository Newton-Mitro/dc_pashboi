import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/pages/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/pages/domain/usecases/fetch_page_usecase.dart';

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
  late PageRemoteDataSourceImpl dataSource;
  const props = PageProps(pageSlug: 'about-us');
  final expectedPath = '${ApiUrls.getPageByPageSlug}/about-us';

  setUp(() {
    apiService = _MockProductApiService();
    dataSource = PageRemoteDataSourceImpl(productApiService: apiService);
  });

  test('fetches a page by slug and parses its page payload', () async {
    when(() => apiService.get(expectedPath)).thenAnswer(
      (_) async => _response(
        path: expectedPath,
        data: {
          'pages': {
            'id': 'page-1',
            'title': 'About Us',
            'slug': 'about-us',
            'order': 1,
            'description': 'Our background',
            'created_at': '2025-01-01T10:00:00.000Z',
            'updated_at': '2025-01-02T10:00:00.000Z',
          },
        },
      ),
    );

    final page = await dataSource.fetchPageDataByPageSlug(props);

    expect(page.id, 'page-1');
    expect(page.title, 'About Us');
    expect(page.longDescription, 'Our background');
    verify(() => apiService.get(expectedPath)).called(1);
  });

  test('rejects a response without a page object', () async {
    when(() => apiService.get(expectedPath)).thenAnswer(
      (_) async => _response(path: expectedPath, data: {'pages': null}),
    );

    expect(
      dataSource.fetchPageDataByPageSlug(props),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('expected a JSON object'),
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
      dataSource.fetchPageDataByPageSlug(props),
      throwsA(isA<Exception>()),
    );
  });
}
