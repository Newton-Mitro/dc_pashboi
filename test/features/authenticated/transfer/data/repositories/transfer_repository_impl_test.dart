import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/transfer/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/transfer/data/repositories/transfer_repository.impl.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';

class _MockRemoteDataSource extends Mock implements TransferRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late TransferRepositoryImpl repository;
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

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = TransferRepositoryImpl(
      transferRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('returns a successful fund transfer message', () async {
    when(
      () => remote.submitFundTransfer(props),
    ).thenAnswer((_) async => 'Transfer completed');

    final result = await repository.submitFundTransfer(props);

    expect(result, const Right<Failure, String>('Transfer completed'));
    verify(() => remote.submitFundTransfer(props)).called(1);
  });

  test('maps remote transfer errors to failures', () async {
    when(
      () => remote.submitFundTransfer(props),
    ).thenThrow(ServerException(message: 'Transfer unavailable'));

    final result = await repository.submitFundTransfer(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Transfer unavailable',
      ),
    );
  });
}
