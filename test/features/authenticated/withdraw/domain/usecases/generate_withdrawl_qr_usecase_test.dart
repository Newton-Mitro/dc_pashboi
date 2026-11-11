import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/repositories/withdrawl_repository.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/usecases/generate_withdrawl_qr_usecase.dart';

class _MockWithdrawlRepository extends Mock implements WithdrawlRepository {}

void main() {
  test('delegates QR generation with the submitted details', () async {
    final repository = _MockWithdrawlRepository();
    final useCase = GenerateWithdrawlQrUseCase(withdrawlRepository: repository);
    const props = GenerateWithdrawlQrProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      amount: 1000,
      otpRegId: 'otp-reg',
      otpValue: '456789',
      accountNumber: 'SA-1',
      cardNumber: '1111222233334444',
      nameOnCard: 'member',
      cardPin: 'pin-hash',
    );
    when(
      () => repository.generateWithdrawlQr(props),
    ).thenAnswer((_) async => const Right<Failure, String>('qr-payload'));

    final result = await useCase.call(props);

    expect(result, const Right<Failure, String>('qr-payload'));
    verify(() => repository.generateWithdrawlQr(props)).called(1);
  });
}
