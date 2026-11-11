import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_type_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/repositories/wooo_repositories.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';

class _MockWoooRepositories extends Mock implements WoooRepositories {}

void main() {
  late _MockWoooRepositories repository;
  final fromDate = DateTime.utc(2025, 6, 1);
  final toDate = DateTime.utc(2025, 6, 30);
  const identity = {
    'email': 'member@example.com',
    'userId': 7,
    'rolePermissionId': 'role-1',
    'personId': 3,
    'employeeCode': 'EMP-3',
    'mobileNumber': '01700000000',
  };
  final typeProps = WooTypeUseCaseProps(
    email: identity['email']! as String,
    userId: identity['userId']! as int,
    rolePermissionId: identity['rolePermissionId']! as String,
    personId: identity['personId']! as int,
    employeeCode: identity['employeeCode']! as String,
    mobileNumber: identity['mobileNumber']! as String,
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

  setUp(() => repository = _MockWoooRepositories());

  test('WoooTypeUseCase delegates type retrieval', () async {
    final types = <WoooTypeEntities>[];
    when(
      () => repository.getWooType(typeProps),
    ).thenAnswer((_) async => Right<Failure, List<WoooTypeEntities>>(types));

    final result = await WoooTypeUseCase(woooRepositories: repository)(
      typeProps,
    );

    expect(result, Right<Failure, List<WoooTypeEntities>>(types));
    verify(() => repository.getWooType(typeProps)).called(1);
  });

  test('SubmitWoooApplicationUseCase delegates application payload', () async {
    when(
      () => repository.submitWoooApplication(applicationProps),
    ).thenAnswer((_) async => const Right<Failure, String>('submitted'));

    final result = await SubmitWoooApplicationUseCase(
      woooRepositories: repository,
    )(applicationProps);

    expect(result, const Right<Failure, String>('submitted'));
    verify(() => repository.submitWoooApplication(applicationProps)).called(1);
  });

  test('GetWoooDataUseCase delegates history filters', () async {
    final records = <WoooDataEntities>[];
    when(
      () => repository.getWoooData(historyProps),
    ).thenAnswer((_) async => Right<Failure, List<WoooDataEntities>>(records));

    final result = await GetWoooDataUseCase(woooRepositories: repository)(
      historyProps,
    );

    expect(result, Right<Failure, List<WoooDataEntities>>(records));
    verify(() => repository.getWoooData(historyProps)).called(1);
  });

  test('UpdateWoooUseCase delegates update payload', () async {
    when(
      () => repository.updateWoooRequest(updateProps),
    ).thenAnswer((_) async => const Right<Failure, String>('updated'));

    final result = await UpdateWoooUseCase(woooRepositories: repository)(
      updateProps,
    );

    expect(result, const Right<Failure, String>('updated'));
    verify(() => repository.updateWoooRequest(updateProps)).called(1);
  });

  test('GetWoooApprovalUsecase delegates approval list filters', () async {
    final records = <WoooDataEntities>[];
    when(
      () => repository.getWoooApprovalData(approvalProps),
    ).thenAnswer((_) async => Right<Failure, List<WoooDataEntities>>(records));

    final result = await GetWoooApprovalUsecase(woooRepositories: repository)(
      approvalProps,
    );

    expect(result, Right<Failure, List<WoooDataEntities>>(records));
    verify(() => repository.getWoooApprovalData(approvalProps)).called(1);
  });

  test('WoooApprovalSubmitUseCase delegates approval response', () async {
    when(
      () => repository.submitWoooApprovalRequest(approvalSubmitProps),
    ).thenAnswer((_) async => const Right<Failure, String>('approved'));

    final result = await WoooApprovalSubmitUseCase(
      woooRepositories: repository,
    )(approvalSubmitProps);

    expect(result, const Right<Failure, String>('approved'));
    verify(
      () => repository.submitWoooApprovalRequest(approvalSubmitProps),
    ).called(1);
  });
}
