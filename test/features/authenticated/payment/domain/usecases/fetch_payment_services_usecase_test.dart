import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/payment/domain/entities/service_entity.dart';
import 'package:pashboi/features/authenticated/payment/domain/repositories/payment_repository.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/fetch_payment_services_usecase.dart';

class _MockRepository extends Mock implements PaymentRepository {}

void main() {
  test('passes authenticated user context to the repository', () async {
    final repository = _MockRepository();
    final useCase = FetchPaymentServicesUseCase(paymentRepository: repository);
    const props = FetchPaymentServicesProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
    );
    final services = <ServiceEntity>[];
    when(
      () => repository.fetchPaymentServices(props),
    ).thenAnswer((_) async => Right<Failure, List<ServiceEntity>>(services));

    final result = await useCase.call(props);

    expect(result, Right<Failure, List<ServiceEntity>>(services));
    verify(() => repository.fetchPaymentServices(props)).called(1);
  });
}
