import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/public/project/domain/entites/project_entity.dart';
import 'package:pashboi/features/public/project/domain/repositories/project_repository.dart';
import 'package:pashboi/features/public/project/domain/usecase/fetch_project_usecase.dart';

class _MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late _MockProjectRepository repository;
  late FetchProjectUseCase useCase;

  setUp(() {
    repository = _MockProjectRepository();
    useCase = FetchProjectUseCase(projectRepository: repository);
  });

  test('delegates fetching projects to the repository', () async {
    final projects = <ProjectEntity>[];
    when(
      () => repository.findProject(),
    ).thenAnswer((_) async => Right<Failure, List<ProjectEntity>>(projects));

    final result = await useCase(NoParams());

    expect(result, Right<Failure, List<ProjectEntity>>(projects));
    verify(() => repository.findProject()).called(1);
  });
}
