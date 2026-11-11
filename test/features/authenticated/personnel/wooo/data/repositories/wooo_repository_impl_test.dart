import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/datasource/wooo_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_data_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/repositories/wooo_repositories_interface_impl.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';
import '../../wooo_test_helpers.dart';

class _MockRemoteDataSource extends Mock implements WoooRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late WoooRepositoriesInterfaceImpl repository;
  final fromDate = DateTime.utc(2025, 6, 1);
  final toDate = DateTime.utc(2025, 6, 30);
  final typeProps = WooTypeUseCaseProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );
  final applicationProps = SubmitWoooApplicationPropsProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-02',
    toDate: '2025-06-03',
    rejoiningDate: '2025-06-04',
    reason: 'Working remotely',
    woooTypeCode: 'REMOTE',
    isHourly: false,
  );
  final historyProps = GetWoooProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: fromDate,
    toDate: toDate,
  );
  final updateProps = UpdateWoooProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-02',
    toDate: '2025-06-03',
    rejoiningDate: '2025-06-04',
    reason: 'Working remotely',
    woooTypeCode: 'REMOTE',
    isHourly: false,
    leaveApplicationId: 5,
  );
  final approvalProps = GetWoooApprovalProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: fromDate,
    toDate: toDate,
  );
  const approvalSubmitProps = WoooApprovalSubmitUseCaseProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    employeeWoooId: '5',
    status: 'Approved',
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = WoooRepositoriesInterfaceImpl(
      woooRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('getWooType returns remote models and maps remote errors', () async {
    final types = <WoooTypeModel>[makeWoooTypeModel()];
    when(() => remote.fetchWoooTypes(typeProps)).thenAnswer((_) async => types);

    final success = await repository.getWooType(typeProps);
    expect(
      success.fold((_) => false, (result) => identical(result, types)),
      isTrue,
    );
    verify(() => remote.fetchWoooTypes(typeProps)).called(1);

    when(
      () => remote.fetchWoooTypes(typeProps),
    ).thenThrow(ServerException(message: 'Types unavailable'));
    final failure = await repository.getWooType(typeProps);
    expect(
      failure.fold((error) => error, (_) => null),
      isA<ServerFailure>().having(
        (error) => error.message,
        'message',
        'Types unavailable',
      ),
    );
  });

  test(
    'submitWoooApplication returns remote result and maps remote errors',
    () async {
      when(
        () => remote.submitWoooApplication(applicationProps),
      ).thenAnswer((_) async => 'submitted');

      expect(
        await repository.submitWoooApplication(applicationProps),
        const Right<Failure, String>('submitted'),
      );

      when(
        () => remote.submitWoooApplication(applicationProps),
      ).thenThrow(ServerException(message: 'Submit failed'));
      expect(
        await repository.submitWoooApplication(applicationProps),
        const Left<Failure, String>(ServerFailure(message: 'Submit failed')),
      );
    },
  );

  test('getWoooData returns remote records and maps remote errors', () async {
    final records = <WoooDataModel>[makeWoooDataModel()];
    when(
      () => remote.getWoooData(historyProps),
    ).thenAnswer((_) async => records);

    final success = await repository.getWoooData(historyProps);
    expect(
      success.fold((_) => false, (result) => identical(result, records)),
      isTrue,
    );
    verify(() => remote.getWoooData(historyProps)).called(1);

    when(
      () => remote.getWoooData(historyProps),
    ).thenThrow(ServerException(message: 'History unavailable'));
    expect(
      await repository.getWoooData(historyProps),
      const Left<Failure, List<WoooDataModel>>(
        ServerFailure(message: 'History unavailable'),
      ),
    );
  });

  test(
    'updateWoooRequest returns remote result and maps remote errors',
    () async {
      when(
        () => remote.updateWoooData(updateProps),
      ).thenAnswer((_) async => 'updated');

      expect(
        await repository.updateWoooRequest(updateProps),
        const Right<Failure, String>('updated'),
      );

      when(
        () => remote.updateWoooData(updateProps),
      ).thenThrow(ServerException(message: 'Update failed'));
      expect(
        await repository.updateWoooRequest(updateProps),
        const Left<Failure, String>(ServerFailure(message: 'Update failed')),
      );
    },
  );

  test('getWoooApprovalData returns records and maps remote errors', () async {
    final records = <WoooDataModel>[makeWoooDataModel(status: 'For approval')];
    when(
      () => remote.fetchWoooApprovalData(approvalProps),
    ).thenAnswer((_) async => records);

    final success = await repository.getWoooApprovalData(approvalProps);
    expect(
      success.fold((_) => false, (result) => identical(result, records)),
      isTrue,
    );
    verify(() => remote.fetchWoooApprovalData(approvalProps)).called(1);

    when(
      () => remote.fetchWoooApprovalData(approvalProps),
    ).thenThrow(ServerException(message: 'Approvals unavailable'));
    expect(
      await repository.getWoooApprovalData(approvalProps),
      const Left<Failure, List<WoooDataModel>>(
        ServerFailure(message: 'Approvals unavailable'),
      ),
    );
  });

  test(
    'submitWoooApprovalRequest returns result and maps remote errors',
    () async {
      when(
        () => remote.submitWoooApprovalData(approvalSubmitProps),
      ).thenAnswer((_) async => 'approved');

      expect(
        await repository.submitWoooApprovalRequest(approvalSubmitProps),
        const Right<Failure, String>('approved'),
      );

      when(
        () => remote.submitWoooApprovalData(approvalSubmitProps),
      ).thenThrow(ServerException(message: 'Approval failed'));
      expect(
        await repository.submitWoooApprovalRequest(approvalSubmitProps),
        const Left<Failure, String>(ServerFailure(message: 'Approval failed')),
      );
    },
  );
}
