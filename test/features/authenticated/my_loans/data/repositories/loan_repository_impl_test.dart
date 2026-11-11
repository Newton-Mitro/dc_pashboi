import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/my_loans/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/my_loans/data/models/loan_account_model.dart';
import 'package:pashboi/features/authenticated/my_loans/data/repositories/loan_repository.impl.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';

class _MockRemoteDataSource extends Mock implements LoanRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late LoanRepositoryImpl repository;
  const props = FetchMyLoansProps(
    email: 'member@example.com',
    userId: 1,
    rolePermissionId: 'role-1',
    personId: 2,
    employeeCode: 'EMP-1',
    mobileNumber: '01700000000',
  );
  final loan = LoanAccountModel(
    id: 1,
    number: 'LN-1',
    typeName: 'Personal',
    loanBalance: 500,
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = LoanRepositoryImpl(
      loanRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('fetchMyLoans returns loans from the remote data source', () async {
    when(() => remote.fetchMyLoans(props)).thenAnswer((_) async => [loan]);

    final result = await repository.fetchMyLoans(props);

    expect(
      result.fold((_) => false, (loans) => identical(loans.single, loan)),
      isTrue,
    );
    verify(() => remote.fetchMyLoans(props)).called(1);
  });

  test('fetchMyLoans maps remote exceptions to failures', () async {
    when(
      () => remote.fetchMyLoans(props),
    ).thenThrow(ServerException(message: 'Loans unavailable'));

    final result = await repository.fetchMyLoans(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Loans unavailable',
      ),
    );
  });
}
