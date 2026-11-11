import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/project/data/data_source/project_remote_data_source.dart';
import 'package:pashboi/features/public/project/data/models/project_model.dart';
import 'package:pashboi/features/public/project/data/repositories/project_repository_impl.dart';

class _MockProjectRemoteDataSource extends Mock
    implements ProjectRemoteDataSource {}

void main() {
  late _MockProjectRemoteDataSource remote;
  late ProjectRepositoryImpl repository;
  final projects = [
    ProjectModel.fromJson({
      'id': 'project-1',
      'title': 'Community Center',
      'order': 4,
      'description': 'A space for local programs',
      'created_at': '2025-01-01T10:00:00.000Z',
      'updated_at': '2025-01-02T10:00:00.000Z',
    }),
  ];

  setUp(() {
    remote = _MockProjectRemoteDataSource();
    repository = ProjectRepositoryImpl(remoteDataSource: remote);
  });

  test('returns projects from the remote data source', () async {
    when(() => remote.findProject()).thenAnswer((_) async => projects);

    final result = await repository.findProject();

    expect(
      result.fold(
        (_) => false,
        (items) => identical(items.single, projects.single),
      ),
      isTrue,
    );
    verify(() => remote.findProject()).called(1);
  });

  test('maps network exceptions to network failures', () async {
    when(
      () => remote.findProject(),
    ).thenThrow(const SocketException('No route to host'));

    final result = await repository.findProject();

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });
}
