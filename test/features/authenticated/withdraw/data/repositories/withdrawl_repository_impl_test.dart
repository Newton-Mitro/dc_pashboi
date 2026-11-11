import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/withdraw/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/withdraw/data/repositories/withdrawl_repository.impl.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/usecases/generate_withdrawl_qr_usecase.dart';

class _MockRemoteDataSource extends Mock implements WithdrawlRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late WithdrawlRepositoryImpl repository;
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

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = WithdrawlRepositoryImpl(
      withdrawlRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('returns the generated withdrawal QR', () async {
    when(
      () => remote.generateWithdrawlQr(props),
    ).thenAnswer((_) async => 'qr-payload');

    final result = await repository.generateWithdrawlQr(props);

    expect(result, const Right<Failure, String>('qr-payload'));
    verify(() => remote.generateWithdrawlQr(props)).called(1);
  });

  test('maps withdrawal errors to failures', () async {
    when(
      () => remote.generateWithdrawlQr(props),
    ).thenThrow(ServerException(message: 'Withdrawal unavailable'));

    final result = await repository.generateWithdrawlQr(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Withdrawal unavailable',
      ),
    );
  });
}
