import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/public/project/domain/entites/project_entity.dart';
import 'package:pashboi/features/public/project/domain/usecase/fetch_project_usecase.dart';
import 'package:pashboi/features/public/project/presentation/bloc/project_bloc.dart';

class _MockFetchProjectUseCase extends Mock implements FetchProjectUseCase {}

void main() {
  late _MockFetchProjectUseCase useCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    useCase = _MockFetchProjectUseCase();
  });

  ProjectBloc buildBloc() => ProjectBloc(projectUseCase: useCase);

  blocTest<ProjectBloc, ProjectState>(
    'emits loading then loaded projects',
    setUp: () {
      when(
        () => useCase.call(any()),
      ).thenAnswer((_) async => const Right<Failure, List<ProjectEntity>>([]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchProjectEvent()),
    expect: () => [const ProjectLoading(), const ProjectSuccess(projects: [])],
    verify: (_) => verify(() => useCase.call(any())).called(1),
  );

  blocTest<ProjectBloc, ProjectState>(
    'emits an error when project loading fails',
    setUp: () {
      when(() => useCase.call(any())).thenAnswer(
        (_) async => const Left<Failure, List<ProjectEntity>>(
          ServerFailure(message: 'Projects unavailable'),
        ),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchProjectEvent()),
    expect:
        () => [
          const ProjectLoading(),
          const ProjectError(error: 'Projects unavailable'),
        ],
  );
}
