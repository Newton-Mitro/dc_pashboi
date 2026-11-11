import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/datasources/employee_details_remote_datasource.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/models/employee_details_model.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/repositories/employee_repositories_impl.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';

class _MockRemoteDataSource extends Mock
    implements EmployeeDetailsRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late _MockNetworkInfo networkInfo;
  late EmployeeRepositoriesImpl repository;
  const props = EmployeeDetailsProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );
  final employee = EmployeeDetailsModel.fromJson({
    'EmployeeId': 7,
    'FullName': 'Member',
  });

  setUp(() {
    remote = _MockRemoteDataSource();
    networkInfo = _MockNetworkInfo();
    repository = EmployeeRepositoriesImpl(
      employeeDetailsRemoteDataSource: remote,
      networkInfo: networkInfo,
    );
  });

  test('returns employee details when connected', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => remote.fetchEmployeeDetailsDataSource(props),
    ).thenAnswer((_) async => employee);

    final result = await repository.getEmployeeDetails(props);

    expect(
      result.fold((_) => false, (value) => identical(value, employee)),
      isTrue,
    );
    verify(() => remote.fetchEmployeeDetailsDataSource(props)).called(1);
  });

  test(
    'returns a network failure without requesting details when offline',
    () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getEmployeeDetails(props);

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<NetworkFailure>().having(
          (failure) => failure.message,
          'message',
          'No internet connection',
        ),
      );
      verifyNever(() => remote.fetchEmployeeDetailsDataSource(props));
    },
  );

  test('maps remote exceptions to failures', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => remote.fetchEmployeeDetailsDataSource(props),
    ).thenThrow(ServerException(message: 'Profile unavailable'));

    final result = await repository.getEmployeeDetails(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Profile unavailable',
      ),
    );
  });
}
