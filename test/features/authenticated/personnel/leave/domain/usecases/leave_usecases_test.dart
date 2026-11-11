import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_info_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_summery_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/search_employee_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/repositories/leave_repository.dart';
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

class _MockLeaveRepository extends Mock implements LeaveRepository {}

LeaveTypeProps _leaveTypeProps() => const LeaveTypeProps(
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
  leaveStageRemarks: 'Please approve',
  formTime: '09:00',
  toTime: '17:00',
  fallbackPersonName: 'Grace Member',
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

AcceptedFallbackRequestParams _acceptedFallbackProps() =>
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

LeaveApplicationEntities _application() => LeaveApplicationEntities(
  id: 'ANL',
  leaveTypeCode: 'ANL',
  leaveType: 'Annual',
  leaveApplicationId: 42,
  employeeId: 7,
  employeeName: 'Member',
  departmentName: 'Operations',
  designationName: 'Officer',
  applicationDate: '2025-01-01',
  rejoiningDate: '2025-01-04',
  totalLeaveDays: 2,
  remarks: 'Family event',
  supervisorName: 'Manager',
  fullName: 'Member',
  fallbackEmployeeCode: 'EMP-4',
  fallbackPersonId: 4,
  fallbackPersonName: 'Grace',
  currentStage: 'Manager',
  stageCode: 'MGR',
  fromDate: DateTime(2025, 1, 2),
  toDate: DateTime(2025, 1, 3),
  employeeCode: 'EMP-3',
);

void main() {
  late _MockLeaveRepository repository;

  setUpAll(() {
    registerFallbackValue(_leaveTypeProps());
    registerFallbackValue(_balanceProps());
    registerFallbackValue(_searchProps());
    registerFallbackValue(_fallbackProps());
    registerFallbackValue(_approvalProps());
    registerFallbackValue(_historyProps());
    registerFallbackValue(_submitProps());
    registerFallbackValue(_submitApprovalProps());
    registerFallbackValue(_acceptedFallbackProps());
    registerFallbackValue(_updateProps());
  });

  setUp(() => repository = _MockLeaveRepository());

  test('LeaveTypeUseCase delegates props and preserves the result', () async {
    final props = _leaveTypeProps();
    final values = <LeaveTypeModel>[
      LeaveTypeModel(id: 'ANL', leaveType: 'Annual'),
    ];
    when(
      () => repository.getLeaveType(props),
    ).thenAnswer((_) async => Right(values));

    expect(
      await LeaveTypeUseCase(leaveRepository: repository)(props),
      Right(values),
    );
    verify(() => repository.getLeaveType(props)).called(1);
  });

  test('LeaveTypeBalanceUseCase delegates the selected leave type', () async {
    final props = _balanceProps();
    final value = LeaveTypeBalanceDto(
      leaveInfo: LeaveInfoModel.fromJson({'LeaveTypeCode': 'ANL'}),
      leaveSummary: [
        LeaveSummeryModel.fromJson({'LeaveTypeCode': 'ANL'}),
      ],
    );
    when(
      () => repository.getLeaveTypeBalance(props),
    ).thenAnswer((_) async => Right(value));

    expect(
      await LeaveTypeBalanceUseCase(leaveRepository: repository)(props),
      Right(value),
    );
    verify(() => repository.getLeaveTypeBalance(props)).called(1);
  });

  test(
    'SearchEmployeeUseCase delegates search text and preserves employees',
    () async {
      final props = _searchProps();
      final values = <SearchEmployeeModel>[
        SearchEmployeeModel(
          fullName: 'Grace',
          dateOfBirth: DateTime(1990),
          employeeId: 4,
          personId: 5,
          employeeCode: 'EMP-4',
        ),
      ];
      when(
        () => repository.getSearchEmployee(props),
      ).thenAnswer((_) async => Right(values));

      expect(
        await SearchEmployeeUseCase(leaveRepository: repository)(props),
        Right(values),
      );
      verify(() => repository.getSearchEmployee(props)).called(1);
    },
  );

  test(
    'FallbackRequestUseCase delegates and returns fallback applications',
    () async {
      final props = _fallbackProps();
      final values = [_application()];
      when(
        () => repository.getFallbackRequest(props),
      ).thenAnswer((_) async => Right(values));

      expect(
        await FallbackRequestUseCase(leaveRepository: repository)(props),
        Right(values),
      );
      verify(() => repository.getFallbackRequest(props)).called(1);
    },
  );

  test('LeaveApprovalUseCase delegates approval filters', () async {
    final props = _approvalProps();
    final values = [_application()];
    when(
      () => repository.getLeaveApproval(props),
    ).thenAnswer((_) async => Right(values));

    expect(
      await LeaveApprovalUseCase(leaveRepository: repository)(props),
      Right(values),
    );
    verify(() => repository.getLeaveApproval(props)).called(1);
  });

  test(
    'LeaveHistoryRequestUseCase delegates the requested date range',
    () async {
      final props = _historyProps();
      final values = [_application()];
      when(
        () => repository.getLeaveHistory(props),
      ).thenAnswer((_) async => Right(values));

      expect(
        await LeaveHistoryRequestUseCase(leaveRepository: repository)(props),
        Right(values),
      );
      verify(() => repository.getLeaveHistory(props)).called(1);
    },
  );

  test('SubmitLeaveApplicationUseCase forwards application details', () async {
    final props = _submitProps();
    when(
      () => repository.submitLeaveApplication(props),
    ).thenAnswer((_) async => const Right('Submitted'));

    expect(
      await SubmitLeaveApplicationUseCase(leaveRepository: repository)(props),
      const Right('Submitted'),
    );
    verify(() => repository.submitLeaveApplication(props)).called(1);
  });

  test('SubmitLeaveApprovalUseCase forwards approval details', () async {
    final props = _submitApprovalProps();
    when(
      () => repository.submitLeaveApproval(props),
    ).thenAnswer((_) async => const Right('Approved'));

    expect(
      await SubmitLeaveApprovalUseCase(leaveRepository: repository)(props),
      const Right('Approved'),
    );
    verify(() => repository.submitLeaveApproval(props)).called(1);
  });

  test('AcceptedFallbackUseCase forwards acceptance details', () async {
    final props = _acceptedFallbackProps();
    when(
      () => repository.getAcceptedFallbackRequest(props),
    ).thenAnswer((_) async => const Right('Accepted'));

    expect(
      await AcceptedFallbackUseCase(leaveRepository: repository)(props),
      const Right('Accepted'),
    );
    verify(() => repository.getAcceptedFallbackRequest(props)).called(1);
  });

  test(
    'UpdateLeaveApplicationRequestUseCase forwards updated application',
    () async {
      final props = _updateProps();
      when(
        () => repository.updateLeaveApplication(props),
      ).thenAnswer((_) async => const Right('Updated'));

      expect(
        await UpdateLeaveApplicationRequestUseCase(leaveRepository: repository)(
          props,
        ),
        const Right('Updated'),
      );
      verify(() => repository.updateLeaveApplication(props)).called(1);
    },
  );
}
