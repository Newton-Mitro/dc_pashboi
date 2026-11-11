import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/payment/domain/repositories/payment_repository.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/submit_payment_usecase.dart';

class _MockRepository extends Mock implements PaymentRepository {}

void main() {
  test('passes payment command to the repository', () async {
    final repository = _MockRepository();
    final useCase = SubmitPaymentUseCase(paymentRepository: repository);
    const props = SubmitPaymentProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      otherField: 'test',
    );
    when(() => repository.submitPayment(props)).thenAnswer(
      (_) async => const Right<Failure, String>('Payment submitted'),
    );

    final result = await useCase.call(props);

    expect(result, const Right<Failure, String>('Payment submitted'));
    verify(() => repository.submitPayment(props)).called(1);
  });
}
