import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/pages/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/pages/data/models/page_model.dart';
import 'package:pashboi/features/public/pages/data/repositories/page_repository_impl.dart';
import 'package:pashboi/features/public/pages/domain/usecases/fetch_page_usecase.dart';

class _MockPageRemoteDataSource extends Mock implements PageRemoteDataSource {}

void main() {
  late _MockPageRemoteDataSource remote;
  late PageRepositoryImpl repository;
  const props = PageProps(pageSlug: 'about-us');
  final page = PageModel.fromJson({
    'id': 'page-1',
    'title': 'About Us',
    'slug': 'about-us',
    'order': 1,
    'description': 'Our background',
    'created_at': '2025-01-01T10:00:00.000Z',
    'updated_at': '2025-01-02T10:00:00.000Z',
  });

  setUp(() {
    remote = _MockPageRemoteDataSource();
    repository = PageRepositoryImpl(pageRemoteDataSource: remote);
  });

  test('returns the page fetched for the requested slug', () async {
    when(
      () => remote.fetchPageDataByPageSlug(props),
    ).thenAnswer((_) async => page);

    final result = await repository.findPageByPageSlug(props);

    expect(
      result.fold((_) => false, (value) => identical(value, page)),
      isTrue,
    );
    verify(() => remote.fetchPageDataByPageSlug(props)).called(1);
  });

  test('maps network exceptions to network failures', () async {
    when(
      () => remote.fetchPageDataByPageSlug(props),
    ).thenThrow(const SocketException('No route to host'));

    final result = await repository.findPageByPageSlug(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });
}
