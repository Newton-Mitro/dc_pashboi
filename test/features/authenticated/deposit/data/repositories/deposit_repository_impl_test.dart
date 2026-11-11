import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/deposit/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/deposit/data/repositories/deposit_repository.impl.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/submit_deposit_now_usecase.dart';

class _MockRemoteDataSource extends Mock implements DepositRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late DepositRepositoryImpl repository;
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

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = DepositRepositoryImpl(
      depositRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('returns a successful deposit message', () async {
    when(
      () => remote.submitDepositNow(props),
    ).thenAnswer((_) async => 'Deposit submitted');

    final result = await repository.submitDepositNow(props);

    expect(result, const Right<Failure, String>('Deposit submitted'));
    verify(() => remote.submitDepositNow(props)).called(1);
  });

  test('maps deposit errors to failures', () async {
    when(
      () => remote.submitDepositNow(props),
    ).thenThrow(ServerException(message: 'Deposit unavailable'));

    final result = await repository.submitDepositNow(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Deposit unavailable',
      ),
    );
  });
}
