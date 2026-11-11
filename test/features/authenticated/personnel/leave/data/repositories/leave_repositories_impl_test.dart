import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/datasource/leave_application_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/fallback_request_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_info_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_summery_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/search_employee_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/repositories/leave_repositories_impl.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/accepted_fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_history_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_blance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/search_employee_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_approvel_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/update_leave_application_request_usecase.dart';

class _MockLeaveRemoteDataSource extends Mock
    implements LeaveApplicationRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

LeaveTypeProps _typeProps() => const LeaveTypeProps(
  email: 'member@example.com',
  userId: 7,
  rolePermissionId: 'role-1',
  personId: 3,
  employeeCode: 'EMP-3',
  mobileNumber: '01700000000',
);

LeaveTypeBalanceProps _balanceProps() => const LeaveTypeBalanceProps(
  email: 'member@example.com',
  userId: 7,
  rolePermissionId: 'role-1',
  personId: 3,
  employeeCode: 'EMP-3',
  mobileNumber: '01700000000',
  leaveTypeCode: 'ANL',
);

SearchEmployee _searchProps() => const SearchEmployee(
  email: 'member@example.com',
  userId: 7,
  rolePermissionId: 'role-1',
  personId: 3,
  employeeCode: 'EMP-3',
  mobileNumber: '01700000000',
  searchText: 'Grace',
);

FallbackRequestUseCaseProps _fallbackProps() =>
    const FallbackRequestUseCaseProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
    );

LeaveApprovalProps _approvalProps() => const LeaveApprovalProps(
  email: 'member@example.com',
  userId: 7,
  rolePermissionId: 'role-1',
  personId: 3,
  employeeCode: 'EMP-3',
  mobileNumber: '01700000000',
  formDate: '2025-01-01',
  toDate: '2025-01-31',
);

LeaveHistoryRequestProps _historyProps() => LeaveHistoryRequestProps(
  email: 'member@example.com',
  userId: 7,
  rolePermissionId: 'role-1',
  personId: 3,
  employeeCode: 'EMP-3',
  mobileNumber: '01700000000',
  fromDate: DateTime(2025, 1, 1),
  toDate: DateTime(2025, 1, 31),
);

SubmitLeaveApplicationProps _submitProps() => const SubmitLeaveApplicationProps(
  email: 'member@example.com',
  userId: 7,
  rolePermissionId: 'role-1',
  personId: 3,
  employeeCode: 'EMP-3',
  mobileNumber: '01700000000',
  remarks: 'Family event',
  fallbackEmployeeCode: 'EMP-4',
  rejoiningDate: '2025-01-04',
  toDate: '2025-01-03',
  fromDate: '2025-01-02',
  leaveTypeCode: 'ANL',
  leaveStageRemarks: 'Approve',
  formTime: '09:00',
  toTime: '17:00',
  fallbackPersonName: 'Grace',
);

SubmitLeaveApprovalProps _submitApprovalProps() =>
    const SubmitLeaveApprovalProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      leaveStageRemarks: 'Approved',
      leaveApplicationId: 42,
    );

AcceptedFallbackRequestParams _acceptedProps() =>
    const AcceptedFallbackRequestParams(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      remarks: 'Accepted',
      leaveApplicationId: 42,
    );

UpdateLeaveApplicationRequestProps _updateProps() =>
    const UpdateLeaveApplicationRequestProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      leaveApplicationId: '42',
      remarks: 'Updated',
      fallbackEmployeeCode: 'EMP-4',
      rejoiningDate: '2025-01-04',
      toDate: '2025-01-03',
      fromDate: '2025-01-02',
      leaveTypeCode: 'ANL',
      leaveStageRemarks: 'Updated',
      formTime: '09:00',
      toTime: '17:00',
    );

void main() {
  late _MockLeaveRemoteDataSource remote;
  late LeaveRepositoriesImpl repository;
  final application = LeaveApplicationRequestModel.fromJson({
    'LeaveTypeCode': 'ANL',
    'LeaveApplicationId': 42,
    'FromDate': '2025-01-01',
    'ToDate': '2025-01-02',
  });
  final balance = LeaveTypeBalanceDto(
    leaveInfo: LeaveInfoModel.fromJson({'LeaveTypeCode': 'ANL'}),
    leaveSummary: [
      LeaveSummeryModel.fromJson({'LeaveTypeCode': 'ANL'}),
    ],
  );

  setUpAll(() {
    registerFallbackValue(_typeProps());
    registerFallbackValue(_balanceProps());
    registerFallbackValue(_searchProps());
    registerFallbackValue(_fallbackProps());
    registerFallbackValue(_approvalProps());
    registerFallbackValue(_historyProps());
    registerFallbackValue(_submitProps());
    registerFallbackValue(_submitApprovalProps());
    registerFallbackValue(_acceptedProps());
    registerFallbackValue(_updateProps());
  });

  setUp(() {
    remote = _MockLeaveRemoteDataSource();
    repository = LeaveRepositoriesImpl(
      leaveApplicationRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test(
    'maps leave type, balance, and employee response models to entities',
    () async {
      final types = [LeaveTypeModel(id: 'ANL', leaveType: 'Annual')];
      final employees = [
        SearchEmployeeModel(
          fullName: 'Grace',
          dateOfBirth: DateTime(1990),
          employeeId: 4,
          personId: 5,
          employeeCode: 'EMP-4',
        ),
      ];
      when(() => remote.fetchLeaveType(any())).thenAnswer((_) async => types);
      when(
        () => remote.fetchLeaveTypeBalance(any()),
      ).thenAnswer((_) async => balance);
      when(
        () => remote.fetchEmployee(any()),
      ).thenAnswer((_) async => employees);

      final typeResult = await repository.getLeaveType(_typeProps());
      final balanceResult = await repository.getLeaveTypeBalance(
        _balanceProps(),
      );
      final employeeResult = await repository.getSearchEmployee(_searchProps());

      expect(typeResult, Right<Failure, List<LeaveTypeModel>>(types));
      expect(balanceResult, Right<Failure, LeaveTypeBalanceDto>(balance));
      expect(
        employeeResult,
        Right<Failure, List<SearchEmployeeModel>>(employees),
      );
      expect(typeResult.getOrElse(() => []).single.leaveType, 'Annual');
      expect(employeeResult.getOrElse(() => []).single.employeeCode, 'EMP-4');
    },
  );

  test('maps application and fallback mutation responses', () async {
    when(
      () => remote.submitLeaveApplication(any()),
    ).thenAnswer((_) async => 'submitted');
    when(
      () => remote.acceptedFallback(any()),
    ).thenAnswer((_) async => 'accepted');
    when(
      () => remote.submitLeaveApproval(any()),
    ).thenAnswer((_) async => 'approved');
    when(
      () => remote.updateLeaveApplication(any()),
    ).thenAnswer((_) async => 'updated');

    expect(
      await repository.submitLeaveApplication(_submitProps()),
      const Right('submitted'),
    );
    expect(
      await repository.getAcceptedFallbackRequest(_acceptedProps()),
      const Right('accepted'),
    );
    expect(
      await repository.submitLeaveApproval(_submitApprovalProps()),
      const Right('approved'),
    );
    expect(
      await repository.updateLeaveApplication(_updateProps()),
      const Right('updated'),
    );
  });

  test(
    'maps all application request lists without losing model fields',
    () async {
      when(
        () => remote.fetchFallbackRequest(any()),
      ).thenAnswer((_) async => [application]);
      when(
        () => remote.fetchLeaveApproval(any()),
      ).thenAnswer((_) async => [application]);
      when(
        () => remote.fetchLeaveHistory(any()),
      ).thenAnswer((_) async => [application]);

      final fallback = await repository.getFallbackRequest(_fallbackProps());
      final approval = await repository.getLeaveApproval(_approvalProps());
      final history = await repository.getLeaveHistory(_historyProps());

      expect(fallback.getOrElse(() => []).single.leaveApplicationId, 42);
      expect(approval.getOrElse(() => []).single.leaveTypeCode, 'ANL');
      expect(history.getOrElse(() => []).single.id, 'ANL');
    },
  );

  test('converts datasource exceptions to typed failures', () async {
    when(
      () => remote.fetchLeaveType(any()),
    ).thenThrow(ServerException(message: 'Leave service unavailable'));

    final result = await repository.getLeaveType(_typeProps());

    expect(result, isA<Left<Failure, List<LeaveTypeModel>>>());
    expect(
      result.swap().getOrElse(() => const ServerFailure()).message,
      'Leave service unavailable',
    );
    verify(() => remote.fetchLeaveType(any())).called(1);
  });
}
