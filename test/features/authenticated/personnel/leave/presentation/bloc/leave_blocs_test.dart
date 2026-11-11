import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/fallback_request_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_info_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_summery_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/search_employee_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
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
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_application_page/bloc/leave_application_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_application_page/bloc/search_employee_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_approval_page/bloc/leave_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_approval_page/widget/bloc/submit_leave_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_fallback_page/bloc/fallback_request_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_fallback_page/wigets/bloc/accepted_fallback_request_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_history_page/bloc/leave_history_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_history_page/wigets/bloc/update_leave_application_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_info_page/bloc/leave_type_balance_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/leave/presentation/pages/leave_info_page/bloc/leave_type_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockSubmitLeaveApplicationUseCase extends Mock
    implements SubmitLeaveApplicationUseCase {}

class _MockSearchEmployeeUseCase extends Mock
    implements SearchEmployeeUseCase {}

class _MockLeaveApprovalUseCase extends Mock implements LeaveApprovalUseCase {}

class _MockSubmitLeaveApprovalUseCase extends Mock
    implements SubmitLeaveApprovalUseCase {}

class _MockFallbackRequestUseCase extends Mock
    implements FallbackRequestUseCase {}

class _MockAcceptedFallbackUseCase extends Mock
    implements AcceptedFallbackUseCase {}

class _MockLeaveHistoryUseCase extends Mock
    implements LeaveHistoryRequestUseCase {}

class _MockUpdateLeaveApplicationUseCase extends Mock
    implements UpdateLeaveApplicationRequestUseCase {}

class _MockLeaveTypeUseCase extends Mock implements LeaveTypeUseCase {}

class _MockLeaveTypeBalanceUseCase extends Mock
    implements LeaveTypeBalanceUseCase {}

UserEntity _user() => UserEntity(
  userId: 7,
  personId: 3,
  loginEmail: 'member@example.com',
  roleId: 'role-1',
  roleName: 'Member',
  userName: 'Member',
  branchCode: 'BR-1',
  regMobile: '01700000000',
  address: 'Central',
  organizationCode: 'ORG',
  deviceId: 1,
  employeeCode: 'EMP-3',
  isNewMenu: false,
  rolePermissions: const [],
);

AuthUserEntity _authUser() => AuthUserEntity(
  accessToken: 'access',
  refreshToken: 'refresh',
  user: _user(),
);

LeaveApplicationEntities _application() =>
    LeaveApplicationRequestModel.fromJson({
      'LeaveTypeCode': 'ANL',
      'LeaveType': 'Annual',
      'LeaveApplicationId': 42,
      'EmployeeId': 7,
      'EmployeeName': 'Member',
      'DepartmentName': 'Operations',
      'DesignationName': 'Officer',
      'ApplicationDate': '2025-01-01',
      'RejoiningDate': '2025-01-04',
      'TotalLeaveDays': 2,
      'Remarks': 'Family event',
      'SupervisorName': 'Manager',
      'FullName': 'Member',
      'FallbackEmployeeCode': 'EMP-4',
      'FallbackPersonId': 4,
      'FallbackPersonName': 'Grace',
      'CurrentStage': 'Manager',
      'StageCode': 'MGR',
      'FromDate': '2025-01-02',
      'ToDate': '2025-01-03',
      'EmployeeCode': 'EMP-3',
    });

void main() {
  late _MockGetAuthUserUseCase auth;
  late AppLocalizationService localization;
  late _MockSubmitLeaveApplicationUseCase submitApplication;
  late _MockSearchEmployeeUseCase searchEmployee;
  late _MockLeaveApprovalUseCase leaveApproval;
  late _MockSubmitLeaveApprovalUseCase submitApproval;
  late _MockFallbackRequestUseCase fallback;
  late _MockAcceptedFallbackUseCase acceptedFallback;
  late _MockLeaveHistoryUseCase leaveHistory;
  late _MockUpdateLeaveApplicationUseCase updateApplication;
  late _MockLeaveTypeUseCase leaveType;
  late _MockLeaveTypeBalanceUseCase leaveTypeBalance;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const SubmitLeaveApplicationProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        remarks: '',
        fallbackEmployeeCode: '',
        rejoiningDate: '',
        toDate: '',
        fromDate: '',
        leaveTypeCode: 'ANL',
        leaveStageRemarks: '',
        formTime: '',
        toTime: '',
        fallbackPersonName: '',
      ),
    );
    registerFallbackValue(
      const SearchEmployee(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        searchText: '',
      ),
    );
    registerFallbackValue(
      const LeaveApprovalProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        formDate: '',
        toDate: '',
      ),
    );
    registerFallbackValue(
      const SubmitLeaveApprovalProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        leaveStageRemarks: '',
        leaveApplicationId: 0,
      ),
    );
    registerFallbackValue(
      const FallbackRequestUseCaseProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
      ),
    );
    registerFallbackValue(
      const AcceptedFallbackRequestParams(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        remarks: '',
        leaveApplicationId: 0,
      ),
    );
    registerFallbackValue(
      LeaveHistoryRequestProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        fromDate: DateTime(2000),
        toDate: DateTime(2000),
      ),
    );
    registerFallbackValue(
      const UpdateLeaveApplicationRequestProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        leaveApplicationId: '',
        remarks: '',
        fallbackEmployeeCode: '',
        rejoiningDate: '',
        toDate: '',
        fromDate: '',
        leaveTypeCode: '',
        leaveStageRemarks: '',
        formTime: '',
        toTime: '',
      ),
    );
    registerFallbackValue(
      const LeaveTypeProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
      ),
    );
    registerFallbackValue(
      const LeaveTypeBalanceProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        leaveTypeCode: '',
      ),
    );
  });

  setUp(() {
    auth = _MockGetAuthUserUseCase();
    localization = AppLocalizationService(GlobalKey<NavigatorState>());
    submitApplication = _MockSubmitLeaveApplicationUseCase();
    searchEmployee = _MockSearchEmployeeUseCase();
    leaveApproval = _MockLeaveApprovalUseCase();
    submitApproval = _MockSubmitLeaveApprovalUseCase();
    fallback = _MockFallbackRequestUseCase();
    acceptedFallback = _MockAcceptedFallbackUseCase();
    leaveHistory = _MockLeaveHistoryUseCase();
    updateApplication = _MockUpdateLeaveApplicationUseCase();
    leaveType = _MockLeaveTypeUseCase();
    leaveTypeBalance = _MockLeaveTypeBalanceUseCase();

    when(() => auth(any())).thenAnswer((_) async => Right(_authUser()));
  });

  blocTest<LeaveApplicationBloc, LeaveApplicationState>(
    'updates leave form fields',
    build:
        () => LeaveApplicationBloc(
          getAuthUserUseCase: auth,
          submitLeaveApplicationUseCase: submitApplication,
          appLocalizationService: localization,
        ),
    act:
        (bloc) => bloc.add(
          const LeaveApplicationUpdateField(
            data: {'description': 'Family event', 'selectedLeaveType': 'ANL'},
          ),
        ),
    expect:
        () => [
          isA<LeaveApplicationState>().having(
            (state) => state.leaveApplicationData,
            'form data',
            {'description': 'Family event', 'selectedLeaveType': 'ANL'},
          ),
        ],
  );

  blocTest<LeaveApplicationBloc, LeaveApplicationState>(
    'submits an application and emits a success message',
    build: () {
      when(
        () => submitApplication(any()),
      ).thenAnswer((_) async => const Right('Submitted'));
      return LeaveApplicationBloc(
        getAuthUserUseCase: auth,
        submitLeaveApplicationUseCase: submitApplication,
        appLocalizationService: localization,
      );
    },
    act: (bloc) async {
      bloc.add(
        const LeaveApplicationUpdateField(
          data: {
            'description': 'Family event',
            'selectedLeaveType': 'ANL',
            'startDate': '2025-01-02',
            'endDate': '2025-01-03',
          },
        ),
      );
      await Future<void>.delayed(Duration.zero);
      bloc.add(const LeaveApplicationSubmitEvent());
    },
    expect:
        () => [
          isA<LeaveApplicationState>(),
          isA<LeaveApplicationState>().having(
            (state) => state.isLoading,
            'loading',
            true,
          ),
          isA<LeaveApplicationState>().having(
            (state) => state.successMessage,
            'success',
            'Submitted',
          ),
        ],
    verify: (_) => verify(() => submitApplication(any())).called(1),
  );

  blocTest<SearchEmployeeBloc, SearchEmployeeState>(
    'loads employee search results',
    build: () {
      when(() => searchEmployee(any())).thenAnswer(
        (_) async => Right([
          SearchEmployeeModel(
            fullName: 'Grace',
            dateOfBirth: DateTime(1990),
            employeeId: 4,
            personId: 5,
            employeeCode: 'EMP-4',
          ),
        ]),
      );
      return SearchEmployeeBloc(
        getAuthUserUseCase: auth,
        searchEmployeeUseCase: searchEmployee,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchSearchEmployeeEvent('Grace')),
    expect:
        () => [
          isA<SearchEmployeeLoading>(),
          isA<SearchEmployeeSuccess>().having(
            (state) => state.employees.single.fullName,
            'employee',
            'Grace',
          ),
        ],
    verify: (_) => verify(() => searchEmployee(any())).called(1),
  );

  blocTest<LeaveApprovalBloc, LeaveApprovalState>(
    'loads leave approvals',
    build: () {
      when(
        () => leaveApproval(any()),
      ).thenAnswer((_) async => Right([_application()]));
      return LeaveApprovalBloc(
        getAuthUserUseCase: auth,
        getLeaveApprovalUseCase: leaveApproval,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const FetchLeaveApprovals(
            fromDate: '2025-01-01',
            toDate: '2025-01-31',
          ),
        ),
    expect:
        () => [
          isA<LeaveApprovalLoading>(),
          isA<LeaveApprovalSuccess>().having(
            (state) => state.approvals.single.leaveApplicationId,
            'application',
            42,
          ),
        ],
    verify: (_) => verify(() => leaveApproval(any())).called(1),
  );

  blocTest<SubmitLeaveApprovalBloc, SubmitLeaveApprovalState>(
    'submits an approval decision',
    build: () {
      when(
        () => submitApproval(any()),
      ).thenAnswer((_) async => const Right('Approved'));
      return SubmitLeaveApprovalBloc(
        getAuthUserUseCase: auth,
        submitLeaveApprovalUseCase: submitApproval,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const SubmitLeaveApprovals(
            leaveStageRemarks: 'Approved',
            leaveApplicationId: 42,
          ),
        ),
    expect:
        () => [
          isA<SubmitLeaveApprovalLoading>(),
          isA<SubmitLeaveApprovalSuccess>().having(
            (state) => state.message,
            'message',
            'Approved',
          ),
        ],
    verify: (_) => verify(() => submitApproval(any())).called(1),
  );

  blocTest<FallbackRequestBloc, FallbackRequestState>(
    'loads fallback requests',
    build: () {
      when(
        () => fallback(any()),
      ).thenAnswer((_) async => Right([_application()]));
      return FallbackRequestBloc(
        getAuthUserUseCase: auth,
        fallbackRequestUseCase: fallback,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchFallbackRequests()),
    expect:
        () => [
          isA<FallbackRequestLoading>(),
          isA<FallbackRequestSuccess>().having(
            (state) => state.requests.single.leaveApplicationId,
            'application',
            42,
          ),
        ],
    verify: (_) => verify(() => fallback(any())).called(1),
  );

  blocTest<AcceptedFallbackRequestBloc, AcceptedFallbackRequestState>(
    'submits an accepted fallback request',
    build: () {
      when(
        () => acceptedFallback(any()),
      ).thenAnswer((_) async => const Right('Accepted'));
      return AcceptedFallbackRequestBloc(
        acceptedFallbackRequestUseCase: acceptedFallback,
        getAuthUserUseCase: auth,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const AcceptedFallbackRequestSubmitted(
            remarks: 'Accepted',
            leaveApplicationId: 42,
          ),
        ),
    expect:
        () => [
          isA<AcceptedFallbackRequestLoading>(),
          isA<AcceptedFallbackRequestSuccess>().having(
            (state) => state.message,
            'message',
            'Accepted',
          ),
        ],
    verify: (_) => verify(() => acceptedFallback(any())).called(1),
  );

  blocTest<LeaveHistoryBloc, LeaveHistoryState>(
    'loads leave history for the selected dates',
    build: () {
      when(
        () => leaveHistory(any()),
      ).thenAnswer((_) async => Right([_application()]));
      return LeaveHistoryBloc(
        getAuthUserUseCase: auth,
        leaveHistoryRequestUseCase: leaveHistory,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          FetchLeaveHistory(
            fromDate: DateTime(2025, 1, 1),
            toDate: DateTime(2025, 1, 31),
          ),
        ),
    expect:
        () => [
          isA<LeaveHistoryLoading>(),
          isA<LeaveHistorySuccess>().having(
            (state) => state.requests.single.leaveApplicationId,
            'application',
            42,
          ),
        ],
    verify: (_) => verify(() => leaveHistory(any())).called(1),
  );

  blocTest<UpdateLeaveApplicationBloc, UpdateLeaveApplicationState>(
    'updates an existing leave application',
    build: () {
      when(
        () => updateApplication(any()),
      ).thenAnswer((_) async => const Right('Updated'));
      return UpdateLeaveApplicationBloc(
        getAuthUserUseCase: auth,
        updateLeaveApplicationRequestUseCase: updateApplication,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const UpdateLeaveApplication(
            leaveApplicationId: '42',
            remarks: 'Updated',
            fallbackEmployeeCode: 'EMP-4',
            rejoiningDate: '2025-01-04',
            toDate: '2025-01-03',
            fromDate: '2025-01-02',
            formTime: '09:00',
            toTime: '17:00',
            leaveTypeCode: 'ANL',
            leaveStageRemarks: 'Updated',
          ),
        ),
    expect:
        () => [
          isA<UpdateLeaveApplicationLoading>(),
          isA<UpdateLeaveApplicationSuccess>().having(
            (state) => state.message,
            'message',
            'Updated',
          ),
        ],
    verify: (_) => verify(() => updateApplication(any())).called(1),
  );

  blocTest<LeaveTypeBloc, LeaveTypeState>(
    'loads available leave types',
    build: () {
      when(() => leaveType(any())).thenAnswer(
        (_) async => Right([LeaveTypeModel(id: 'ANL', leaveType: 'Annual')]),
      );
      return LeaveTypeBloc(
        getAuthUserUseCase: auth,
        leaveTypeUseCase: leaveType,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchLeaveTypeEvent()),
    expect:
        () => [
          isA<LeaveTypeLoading>(),
          isA<LeaveTypeSuccess>().having(
            (state) => state.leaveTypeEntity.single.id,
            'leave type',
            'ANL',
          ),
        ],
    verify: (_) => verify(() => leaveType(any())).called(1),
  );

  blocTest<LeaveTypeBalanceBloc, LeaveTypeBalanceState>(
    'loads balance details for a leave type',
    build: () {
      when(() => leaveTypeBalance(any())).thenAnswer(
        (_) async => Right(
          LeaveTypeBalanceDto(
            leaveInfo: LeaveInfoModel.fromJson({'LeaveTypeCode': 'ANL'}),
            leaveSummary: [
              LeaveSummeryModel.fromJson({'LeaveTypeCode': 'ANL'}),
            ],
          ),
        ),
      );
      return LeaveTypeBalanceBloc(
        getAuthUserUseCase: auth,
        leaveTypeBalanceUseCase: leaveTypeBalance,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchLeaveTypeBalanceEvent('ANL')),
    expect:
        () => [
          isA<LeaveTypeBalanceLoading>(),
          isA<LeaveTypeBalanceSuccess>().having(
            (state) => state.leaveTypeBalance.leaveInfo.leaveTypeCode,
            'leave type code',
            'ANL',
          ),
        ],
    verify: (_) => verify(() => leaveTypeBalance(any())).called(1),
  );

  blocTest<SearchEmployeeBloc, SearchEmployeeState>(
    'reports employee search failures',
    build: () {
      when(() => searchEmployee(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Search unavailable')),
      );
      return SearchEmployeeBloc(
        getAuthUserUseCase: auth,
        searchEmployeeUseCase: searchEmployee,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchSearchEmployeeEvent('unknown')),
    expect:
        () => [
          isA<SearchEmployeeLoading>(),
          isA<SearchEmployeeError>().having(
            (state) => state.message,
            'message',
            'Search unavailable',
          ),
        ],
  );

  blocTest<LeaveApprovalBloc, LeaveApprovalState>(
    'reports approval list failures',
    build: () {
      when(() => leaveApproval(any())).thenAnswer(
        (_) async =>
            Left(const ServerFailure(message: 'Approvals unavailable')),
      );
      return LeaveApprovalBloc(
        getAuthUserUseCase: auth,
        getLeaveApprovalUseCase: leaveApproval,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const FetchLeaveApprovals(
            fromDate: '2025-01-01',
            toDate: '2025-01-31',
          ),
        ),
    expect:
        () => [
          isA<LeaveApprovalLoading>(),
          isA<LeaveApprovalError>().having(
            (state) => state.message,
            'message',
            'Approvals unavailable',
          ),
        ],
  );

  blocTest<SubmitLeaveApprovalBloc, SubmitLeaveApprovalState>(
    'reports approval submission failures',
    build: () {
      when(() => submitApproval(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Approval rejected')),
      );
      return SubmitLeaveApprovalBloc(
        getAuthUserUseCase: auth,
        submitLeaveApprovalUseCase: submitApproval,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const SubmitLeaveApprovals(
            leaveStageRemarks: 'Approve',
            leaveApplicationId: 42,
          ),
        ),
    expect:
        () => [
          isA<SubmitLeaveApprovalLoading>(),
          isA<SubmitLeaveApprovalError>().having(
            (state) => state.message,
            'message',
            'Approval rejected',
          ),
        ],
  );

  blocTest<FallbackRequestBloc, FallbackRequestState>(
    'reports fallback list failures',
    build: () {
      when(() => fallback(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Fallback unavailable')),
      );
      return FallbackRequestBloc(
        getAuthUserUseCase: auth,
        fallbackRequestUseCase: fallback,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchFallbackRequests()),
    expect:
        () => [
          isA<FallbackRequestLoading>(),
          isA<FallbackRequestError>().having(
            (state) => state.message,
            'message',
            'Fallback unavailable',
          ),
        ],
  );

  blocTest<AcceptedFallbackRequestBloc, AcceptedFallbackRequestState>(
    'reports accepted fallback submission failures',
    build: () {
      when(() => acceptedFallback(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Acceptance rejected')),
      );
      return AcceptedFallbackRequestBloc(
        acceptedFallbackRequestUseCase: acceptedFallback,
        getAuthUserUseCase: auth,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const AcceptedFallbackRequestSubmitted(
            remarks: 'Accept',
            leaveApplicationId: 42,
          ),
        ),
    expect:
        () => [
          isA<AcceptedFallbackRequestLoading>(),
          isA<AcceptedFallbackRequestError>().having(
            (state) => state.message,
            'message',
            'Acceptance rejected',
          ),
        ],
  );

  blocTest<LeaveHistoryBloc, LeaveHistoryState>(
    'reports leave history failures',
    build: () {
      when(() => leaveHistory(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'History unavailable')),
      );
      return LeaveHistoryBloc(
        getAuthUserUseCase: auth,
        leaveHistoryRequestUseCase: leaveHistory,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          FetchLeaveHistory(
            fromDate: DateTime(2025, 1, 1),
            toDate: DateTime(2025, 1, 31),
          ),
        ),
    expect:
        () => [
          isA<LeaveHistoryLoading>(),
          isA<LeaveHistoryError>().having(
            (state) => state.message,
            'message',
            'History unavailable',
          ),
        ],
  );

  blocTest<UpdateLeaveApplicationBloc, UpdateLeaveApplicationState>(
    'reports leave application update failures',
    build: () {
      when(() => updateApplication(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Update rejected')),
      );
      return UpdateLeaveApplicationBloc(
        getAuthUserUseCase: auth,
        updateLeaveApplicationRequestUseCase: updateApplication,
        appLocalizationService: localization,
      );
    },
    act:
        (bloc) => bloc.add(
          const UpdateLeaveApplication(
            leaveApplicationId: '42',
            remarks: 'Updated',
            fallbackEmployeeCode: 'EMP-4',
            rejoiningDate: '2025-01-04',
            toDate: '2025-01-03',
            fromDate: '2025-01-02',
            formTime: '09:00',
            toTime: '17:00',
            leaveTypeCode: 'ANL',
            leaveStageRemarks: 'Updated',
          ),
        ),
    expect:
        () => [
          isA<UpdateLeaveApplicationLoading>(),
          isA<UpdateLeaveApplicationError>().having(
            (state) => state.message,
            'message',
            'Update rejected',
          ),
        ],
  );

  blocTest<LeaveTypeBloc, LeaveTypeState>(
    'reports leave type lookup failures',
    build: () {
      when(() => leaveType(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Types unavailable')),
      );
      return LeaveTypeBloc(
        getAuthUserUseCase: auth,
        leaveTypeUseCase: leaveType,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchLeaveTypeEvent()),
    expect:
        () => [
          isA<LeaveTypeLoading>(),
          isA<LeaveTypeError>().having(
            (state) => state.message,
            'message',
            'Types unavailable',
          ),
        ],
  );

  blocTest<LeaveTypeBalanceBloc, LeaveTypeBalanceState>(
    'reports leave balance lookup failures',
    build: () {
      when(() => leaveTypeBalance(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Balance unavailable')),
      );
      return LeaveTypeBalanceBloc(
        getAuthUserUseCase: auth,
        leaveTypeBalanceUseCase: leaveTypeBalance,
        appLocalizationService: localization,
      );
    },
    act: (bloc) => bloc.add(const FetchLeaveTypeBalanceEvent('ANL')),
    expect:
        () => [
          isA<LeaveTypeBalanceLoading>(),
          isA<LeaveTypeBalanceError>().having(
            (state) => state.message,
            'message',
            'Balance unavailable',
          ),
        ],
  );

  blocTest<LeaveApplicationBloc, LeaveApplicationState>(
    'reports application submission failures',
    build: () {
      when(() => submitApplication(any())).thenAnswer(
        (_) async => Left(const ServerFailure(message: 'Submission rejected')),
      );
      return LeaveApplicationBloc(
        getAuthUserUseCase: auth,
        submitLeaveApplicationUseCase: submitApplication,
        appLocalizationService: localization,
      );
    },
    act: (bloc) async {
      bloc.add(
        const LeaveApplicationUpdateField(data: {'selectedLeaveType': 'ANL'}),
      );
      await Future<void>.delayed(Duration.zero);
      bloc.add(const LeaveApplicationSubmitEvent());
    },
    expect:
        () => [
          isA<LeaveApplicationState>(),
          isA<LeaveApplicationState>().having(
            (state) => state.isLoading,
            'loading',
            true,
          ),
          isA<LeaveApplicationState>().having(
            (state) => state.error,
            'error',
            'Submission rejected',
          ),
        ],
  );
}
