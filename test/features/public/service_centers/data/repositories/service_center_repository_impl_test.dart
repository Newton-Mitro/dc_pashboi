import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/service_centers/data/data_source/remort_service_center_datasource.dart';
import 'package:pashboi/features/public/service_centers/data/models/service_center_model.dart';
import 'package:pashboi/features/public/service_centers/data/repositories/service_center_repository_impl.dart';

class _MockServiceCenterDataSource extends Mock
    implements ServiceCenterRemoteDataSource {}

void main() {
  late _MockServiceCenterDataSource dataSource;
  late ServiceCenterRepositoryImpl repository;
  final branches = [
    ServiceCenterModel.fromJson({
      'id': 'branch-1',
      'name': 'Central Branch',
      'created_at': '2025-01-01T10:00:00.000Z',
      'updated_at': '2025-01-02T10:00:00.000Z',
    }),
  ];

  setUp(() {
    dataSource = _MockServiceCenterDataSource();
    repository = ServiceCenterRepositoryImpl(remoteDataSource: dataSource);
  });

  test('returns the service centers supplied by the remote source', () async {
    when(
      () => dataSource.findAllServiceCenters(),
    ).thenAnswer((_) async => branches);

    final result = await repository.findAllServiceCenter();

    expect(
      result.fold(
        (_) => false,
        (items) => identical(items.single, branches.single),
      ),
      isTrue,
    );
    verify(() => dataSource.findAllServiceCenters()).called(1);
  });

  test('maps network exceptions to network failures', () async {
    when(
      () => dataSource.findAllServiceCenters(),
    ).thenThrow(const SocketException('No route to host'));

    final result = await repository.findAllServiceCenter();

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });
}
