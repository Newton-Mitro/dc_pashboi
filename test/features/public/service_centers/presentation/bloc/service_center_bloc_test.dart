import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/public/service_centers/domain/entites/service_center_entity.dart';
import 'package:pashboi/features/public/service_centers/domain/usecase/fetch_service_center_usecase.dart';
import 'package:pashboi/features/public/service_centers/presentation/bloc/service_center_bloc.dart';

class _MockFetchServiceCenterUseCase extends Mock
    implements FetchServiceCenterUseCase {}

void main() {
  late _MockFetchServiceCenterUseCase useCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    useCase = _MockFetchServiceCenterUseCase();
  });

  ServiceCenterBloc buildBloc() =>
      ServiceCenterBloc(fetchServiceCenterUseCase: useCase);

  blocTest<ServiceCenterBloc, ServiceCenterState>(
    'emits loading then loaded service centers',
    setUp: () {
      when(() => useCase.call(any())).thenAnswer(
        (_) async => const Right<Failure, List<ServiceCenterEntity>>([]),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchServiceCenterEvent()),
    expect:
        () => [
          const ServiceCenterLoading(),
          const ServiceCenterSuccess(serviceCenter: []),
        ],
    verify: (_) => verify(() => useCase.call(any())).called(1),
  );

  blocTest<ServiceCenterBloc, ServiceCenterState>(
    'emits the repository failure',
    setUp: () {
      when(() => useCase.call(any())).thenAnswer(
        (_) async => const Left<Failure, List<ServiceCenterEntity>>(
          ServerFailure(message: 'Branches unavailable'),
        ),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchServiceCenterEvent()),
    expect:
        () => [
          const ServiceCenterLoading(),
          const ServiceCenterError(error: 'Branches unavailable'),
        ],
  );
}
