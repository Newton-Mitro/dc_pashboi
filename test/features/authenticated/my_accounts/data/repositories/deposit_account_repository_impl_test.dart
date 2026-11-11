import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/datasources/deposit_account_remote.datasource.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/models/deposit_account_model.dart';
import 'package:pashboi/features/authenticated/my_accounts/data/repositories/deposit_account_repository.impl.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_my_accounts_usecase.dart';

class _MockRemoteDataSource extends Mock
    implements DepositAccountRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late DepositAccountRepositoryImpl repository;
  final props = GetMyAccountsProps(
    email: 'member@example.com',
    userId: 1,
    rolePermissionId: 'role-1',
    personId: 2,
    employeeCode: 'EMP-1',
    mobileNumber: '01700000000',
    accountHolderPersonId: 3,
  );
  final account = DepositAccountModel(
    id: 1,
    number: 'SA-1',
    name: 'Member',
    accountHolderId: 2,
    accountHolderName: 'Member',
    shortTypeName: 'SA',
    typeName: 'Savings',
    typeCode: '01',
    balance: 100,
    withdrawableBalance: 100,
    lastPaidDate: null,
    nominees: '',
    maturityDate: null,
    mobileNumber: '01700000000',
    ledgerId: 1,
    interestReate: 0,
    accountFor: 'Personal',
    status: 'Active',
    defaultAccount: false,
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = DepositAccountRepositoryImpl(
      depositAccountRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('getMyAccounts returns accounts from the remote data source', () async {
    when(() => remote.getMyAccounts(props)).thenAnswer((_) async => [account]);

    final result = await repository.getMyAccounts(props);

    expect(
      result.fold(
        (_) => false,
        (accounts) => identical(accounts.single, account),
      ),
      isTrue,
    );
    verify(() => remote.getMyAccounts(props)).called(1);
  });

  test('getMyAccounts maps remote exceptions to failures', () async {
    when(
      () => remote.getMyAccounts(props),
    ).thenThrow(ServerException(message: 'Accounts unavailable'));

    final result = await repository.getMyAccounts(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Accounts unavailable',
      ),
    );
  });
}
