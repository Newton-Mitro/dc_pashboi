import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/beneficiaries/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/beneficiaries/data/models/beneficiary_model.dart';
import 'package:pashboi/features/authenticated/beneficiaries/data/repositories/beneficiary_repository.impl.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/fetch_beneficiaries_usecase.dart';

class _MockRemoteDataSource extends Mock
    implements BeneficiaryRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late BeneficiaryRepositoryImpl repository;
  const props = FetchBeneficiariesProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );
  final beneficiary = BeneficiaryModel(
    id: 2,
    name: 'Payee',
    accountNumber: 'SA-2',
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = BeneficiaryRepositoryImpl(
      beneficiaryRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('returns beneficiaries from the remote data source', () async {
    when(
      () => remote.fetchBeneficiaries(props),
    ).thenAnswer((_) async => [beneficiary]);

    final result = await repository.fetchBeneficiaries(props);

    expect(
      result.fold(
        (_) => false,
        (items) => identical(items.single, beneficiary),
      ),
      isTrue,
    );
    verify(() => remote.fetchBeneficiaries(props)).called(1);
  });

  test('maps remote exceptions to failures', () async {
    when(
      () => remote.fetchBeneficiaries(props),
    ).thenThrow(ServerException(message: 'Beneficiaries unavailable'));

    final result = await repository.fetchBeneficiaries(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Beneficiaries unavailable',
      ),
    );
  });
}
