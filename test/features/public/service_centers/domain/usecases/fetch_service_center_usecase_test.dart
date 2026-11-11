import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/public/service_centers/domain/entites/service_center_entity.dart';
import 'package:pashboi/features/public/service_centers/domain/repositories/service_center_repository.dart';
import 'package:pashboi/features/public/service_centers/domain/usecase/fetch_service_center_usecase.dart';

class _MockServiceCenterRepository extends Mock
    implements ServiceCenterRepository {}

void main() {
  late _MockServiceCenterRepository repository;
  late FetchServiceCenterUseCase useCase;

  setUp(() {
    repository = _MockServiceCenterRepository();
    useCase = FetchServiceCenterUseCase(serviceCenterRepository: repository);
  });

  test('delegates fetching service centers to the repository', () async {
    final branches = <ServiceCenterEntity>[];
    when(() => repository.findAllServiceCenter()).thenAnswer(
      (_) async => Right<Failure, List<ServiceCenterEntity>>(branches),
    );

    final result = await useCase(NoParams());

    expect(result, Right<Failure, List<ServiceCenterEntity>>(branches));
    verify(() => repository.findAllServiceCenter()).called(1);
  });
}
