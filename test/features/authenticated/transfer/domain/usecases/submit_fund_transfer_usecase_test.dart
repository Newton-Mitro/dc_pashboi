import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/transfer/domain/repositories/transfer_repository.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';

class _MockTransferRepository extends Mock implements TransferRepository {}

void main() {
  test('passes the complete request to the repository', () async {
    final repository = _MockTransferRepository();
    final useCase = SubmitFundTransferUseCase(transferRepository: repository);
    const props = SubmitFundTransferProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      amount: 500,
      otpRegId: 'otp-reg',
      otpValue: '123456',
      accountNumber: 'SA-1',
      toAccountNumber: 'SA-2',
      accountType: 'Savings',
      cardNumber: '1111222233334444',
      nameOnCard: 'member',
      cardPin: 'pin-hash',
    );
    when(() => repository.submitFundTransfer(props)).thenAnswer(
      (_) async => const Right<Failure, String>('Transfer completed'),
    );

    final result = await useCase.call(props);

    expect(result, const Right<Failure, String>('Transfer completed'));
    verify(() => repository.submitFundTransfer(props)).called(1);
  });
}
