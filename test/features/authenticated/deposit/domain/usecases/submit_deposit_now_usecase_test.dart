import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/deposit/domain/repositories/deposit_repository.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_now_usecase.dart';

class _MockDepositRepository extends Mock implements DepositRepository {}

void main() {
  test('forwards the deposit request to the repository', () async {
    final repository = _MockDepositRepository();
    final useCase = SubmitDepositNowUseCase(depositRepository: repository);
    const props = SubmitDepositNowProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      accountNumber: 'SA-1',
      accountHolderName: 'member',
      accountId: 1,
      accountType: 'Savings',
      cardNumber: '1111222233334444',
      depositDate: '2025-06-18',
      ledgerId: 2,
      nameOnCard: 'Member',
      totalDepositAmount: 1000,
      cardPin: 'pin-hash',
      transactionMethod: '12',
      otpRegId: 'otp-reg',
      otpValue: '123456',
      transactionType: 'DepositRequest',
      collectionLedgers: [],
    );
    when(() => repository.submitDepositNow(props)).thenAnswer(
      (_) async => const Right<Failure, String>('Deposit submitted'),
    );

    final result = await useCase.call(props);

    expect(result, const Right<Failure, String>('Deposit submitted'));
    verify(() => repository.submitDepositNow(props)).called(1);
  });
}
