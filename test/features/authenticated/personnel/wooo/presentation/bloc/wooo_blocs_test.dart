import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_type_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/woo_approval/bloc/get_wooo_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/woo_approval/wigets/bloc/submit_wooo_approval_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/bloc/wooo_type_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_application/widget/bloc/submit_wooo_application_bloc.dart'
    hide SubmitWoooApplicationEvent;
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_history/bloc/get_wooo_data_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/presentation/pages/wooo_history/wigets/bloc/update_wooo_request_bloc.dart';
import '../../wooo_test_helpers.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockWoooTypeUseCase extends Mock implements WoooTypeUseCase {}

class _MockSubmitWoooApplicationUseCase extends Mock
    implements SubmitWoooApplicationUseCase {}

class _MockGetWoooDataUseCase extends Mock implements GetWoooDataUseCase {}

class _MockUpdateWoooUseCase extends Mock implements UpdateWoooUseCase {}

class _MockGetWoooApprovalUsecase extends Mock
    implements GetWoooApprovalUsecase {}

class _MockWoooApprovalSubmitUseCase extends Mock
    implements WoooApprovalSubmitUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockWoooTypeUseCase typeUseCase;
  late _MockSubmitWoooApplicationUseCase submitUseCase;
  late _MockGetWoooDataUseCase historyUseCase;
  late _MockUpdateWoooUseCase updateUseCase;
  late _MockGetWoooApprovalUsecase approvalListUseCase;
  late _MockWoooApprovalSubmitUseCase approvalSubmitUseCase;
  late _MockLocalizationService localizationService;

  final fromDate = DateTime.utc(2025, 6, 1);
  final toDate = DateTime.utc(2025, 6, 30);
  const typeProps = WooTypeUseCaseProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );
  final applicationEvent = SubmitWoooApplication(
    fromDate: '2025-06-02',
    toDate: '2025-06-03',
    rejoiningDate: '2025-06-04',
    reason: 'Working remotely',
    woooTypeCode: 'REMOTE',
    isHourly: true,
  );
  final historyEvent = FetchWoooDataEvent(fromDate: fromDate, toDate: toDate);
  final updateEvent = UpdateWoooApplication(
    fromDate: '2025-06-02',
    toDate: '2025-06-03',
    rejoiningDate: '2025-06-04',
    reason: 'Updated remote work',
    woooTypeCode: 'REMOTE',
    isHourly: false,
    leaveApplicationId: 5,
  );
  final approvalListEvent = FetchWoooApprovalDataEvent(
    fromDate: fromDate,
    toDate: toDate,
  );
  const approvalEvent = SubmitWoooApplicationEvent(
    status: 'Approved',
    employeeWoooId: '5',
  );
  final types = <WoooTypeEntities>[makeWoooTypeModel()];
  final history = <WoooDataEntities>[makeWoooDataModel()];
  final approvals = <WoooDataEntities>[
    makeWoooDataModel(status: 'For approval'),
  ];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(typeProps);
    registerFallbackValue(
      SubmitWoooApplicationPropsProps(
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
        isHourly: true,
      ),
    );
    registerFallbackValue(
      GetWoooProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
    registerFallbackValue(
      UpdateWoooProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        fromDate: '2025-06-02',
        toDate: '2025-06-03',
        rejoiningDate: '2025-06-04',
        reason: 'Updated remote work',
        woooTypeCode: 'REMOTE',
        isHourly: false,
        leaveApplicationId: 5,
      ),
    );
    registerFallbackValue(
      GetWoooApprovalProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
    registerFallbackValue(
      const WoooApprovalSubmitUseCaseProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        employeeWoooId: '5',
        status: 'Approved',
      ),
    );
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    typeUseCase = _MockWoooTypeUseCase();
    submitUseCase = _MockSubmitWoooApplicationUseCase();
    historyUseCase = _MockGetWoooDataUseCase();
    updateUseCase = _MockUpdateWoooUseCase();
    approvalListUseCase = _MockGetWoooApprovalUsecase();
    approvalSubmitUseCase = _MockWoooApprovalSubmitUseCase();
    localizationService = _MockLocalizationService();
  });

  void authenticateSuccessfully() {
    when(
      () => getAuthUserUseCase.call(any()),
    ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(testWoooAuthUser));
  }

  void failAuthentication() {
    when(() => getAuthUserUseCase.call(any())).thenAnswer(
      (_) async => const Left<Failure, AuthUserEntity>(
        ServerFailure(message: 'User unavailable'),
      ),
    );
  }

  WoooTypeBloc createTypeBloc() => WoooTypeBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    woooTypeUseCase: typeUseCase,
    appLocalizationService: localizationService,
  );

  SubmitWoooApplicationBloc createSubmitBloc() => SubmitWoooApplicationBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    submitWoooApplicationUseCase: submitUseCase,
    appLocalizationService: localizationService,
  );

  GetWoooDataBloc createHistoryBloc() => GetWoooDataBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    getWoooDataUseCase: historyUseCase,
    appLocalizationService: localizationService,
  );

  UpdateWoooRequestBloc createUpdateBloc() => UpdateWoooRequestBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    updateWoooUseCase: updateUseCase,
    appLocalizationService: localizationService,
  );

  GetWoooApprovalBloc createApprovalListBloc() => GetWoooApprovalBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    getWoooApprovalUsecase: approvalListUseCase,
    appLocalizationService: localizationService,
  );

  SubmitWoooApprovalBloc createApprovalSubmitBloc() => SubmitWoooApprovalBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    woooApprovalSubmitUseCase: approvalSubmitUseCase,
    appLocalizationService: localizationService,
  );

  group('WoooTypeBloc', () {
    blocTest<WoooTypeBloc, WoooTypeState>(
      'loads available WOOO types using the authenticated user',
      setUp: () {
        authenticateSuccessfully();
        when(() => typeUseCase.call(any())).thenAnswer(
          (_) async => Right<Failure, List<WoooTypeEntities>>(types),
        );
      },
      build: createTypeBloc,
      act: (bloc) => bloc.add(const FetchWoooTypeEvent()),
      expect: () => [const WoooTypeLoading(), WoooTypeSuccess(types)],
      verify: (_) {
        final props =
            verify(() => typeUseCase.call(captureAny())).captured.single
                as WooTypeUseCaseProps;
        expect(props, typeProps);
      },
    );

    blocTest<WoooTypeBloc, WoooTypeState>(
      'reports authentication failures without requesting types',
      setUp: failAuthentication,
      build: createTypeBloc,
      act: (bloc) => bloc.add(const FetchWoooTypeEvent()),
      expect:
          () => [
            const WoooTypeLoading(),
            const WoooTypeError('User unavailable'),
          ],
      verify: (_) => verifyNever(() => typeUseCase.call(any())),
    );

    blocTest<WoooTypeBloc, WoooTypeState>(
      'reports errors returned while loading types',
      setUp: () {
        authenticateSuccessfully();
        when(() => typeUseCase.call(any())).thenAnswer(
          (_) async => const Left<Failure, List<WoooTypeEntities>>(
            ServerFailure(message: 'Types unavailable'),
          ),
        );
      },
      build: createTypeBloc,
      act: (bloc) => bloc.add(const FetchWoooTypeEvent()),
      expect:
          () => [
            const WoooTypeLoading(),
            const WoooTypeError('Types unavailable'),
          ],
    );
  });

  group('SubmitWoooApplicationBloc', () {
    blocTest<SubmitWoooApplicationBloc, SubmitWoooApplicationState>(
      'submits the application fields for the authenticated user',
      setUp: () {
        authenticateSuccessfully();
        when(
          () => submitUseCase.call(any()),
        ).thenAnswer((_) async => const Right<Failure, String>('Submitted'));
      },
      build: createSubmitBloc,
      act: (bloc) => bloc.add(applicationEvent),
      expect:
          () => [
            const SubmitWoooApplicationLoading(),
            const SubmitWoooApplicationSuccess('Submitted'),
          ],
      verify: (_) {
        final props =
            verify(() => submitUseCase.call(captureAny())).captured.single
                as SubmitWoooApplicationPropsProps;
        expect(props.email, 'member@example.com');
        expect(props.userId, 7);
        expect(props.rolePermissionId, 'role-1');
        expect(props.personId, 3);
        expect(props.employeeCode, 'EMP-3');
        expect(props.mobileNumber, '01700000000');
        expect(props.fromDate, applicationEvent.fromDate);
        expect(props.toDate, applicationEvent.toDate);
        expect(props.rejoiningDate, applicationEvent.rejoiningDate);
        expect(props.reason, applicationEvent.reason);
        expect(props.woooTypeCode, applicationEvent.woooTypeCode);
        expect(props.isHourly, applicationEvent.isHourly);
      },
    );

    blocTest<SubmitWoooApplicationBloc, SubmitWoooApplicationState>(
      'reports authentication failures without submitting an application',
      setUp: failAuthentication,
      build: createSubmitBloc,
      act: (bloc) => bloc.add(applicationEvent),
      expect:
          () => [
            const SubmitWoooApplicationLoading(),
            const SubmitWoooApplicationError('User unavailable'),
          ],
      verify: (_) => verifyNever(() => submitUseCase.call(any())),
    );

    blocTest<SubmitWoooApplicationBloc, SubmitWoooApplicationState>(
      'reports application submission failures',
      setUp: () {
        authenticateSuccessfully();
        when(() => submitUseCase.call(any())).thenAnswer(
          (_) async => const Left<Failure, String>(
            ServerFailure(message: 'Submission failed'),
          ),
        );
      },
      build: createSubmitBloc,
      act: (bloc) => bloc.add(applicationEvent),
      expect:
          () => [
            const SubmitWoooApplicationLoading(),
            const SubmitWoooApplicationError('Submission failed'),
          ],
    );
  });

  group('GetWoooDataBloc', () {
    blocTest<GetWoooDataBloc, GetWoooDataState>(
      'loads history for the selected date range and authenticated user',
      setUp: () {
        authenticateSuccessfully();
        when(() => historyUseCase.call(any())).thenAnswer(
          (_) async => Right<Failure, List<WoooDataEntities>>(history),
        );
      },
      build: createHistoryBloc,
      act: (bloc) => bloc.add(historyEvent),
      expect: () => [GetWoooDataLoading(), GetWoooDataSuccess(history)],
      verify: (_) {
        final props =
            verify(() => historyUseCase.call(captureAny())).captured.single
                as GetWoooProps;
        expect(props.email, 'member@example.com');
        expect(props.userId, 7);
        expect(props.rolePermissionId, 'role-1');
        expect(props.personId, 3);
        expect(props.employeeCode, 'EMP-3');
        expect(props.mobileNumber, '01700000000');
        expect(props.fromDate, fromDate);
        expect(props.toDate, toDate);
      },
    );

    blocTest<GetWoooDataBloc, GetWoooDataState>(
      'reports authentication failures without requesting history',
      setUp: failAuthentication,
      build: createHistoryBloc,
      act: (bloc) => bloc.add(historyEvent),
      expect:
          () => [
            GetWoooDataLoading(),
            const GetWoooDataError('User unavailable'),
          ],
      verify: (_) => verifyNever(() => historyUseCase.call(any())),
    );

    blocTest<GetWoooDataBloc, GetWoooDataState>(
      'reports history retrieval failures',
      setUp: () {
        authenticateSuccessfully();
        when(() => historyUseCase.call(any())).thenAnswer(
          (_) async => const Left<Failure, List<WoooDataEntities>>(
            ServerFailure(message: 'History unavailable'),
          ),
        );
      },
      build: createHistoryBloc,
      act: (bloc) => bloc.add(historyEvent),
      expect:
          () => [
            GetWoooDataLoading(),
            const GetWoooDataError('History unavailable'),
          ],
    );
  });

  group('UpdateWoooRequestBloc', () {
    blocTest<UpdateWoooRequestBloc, UpdateWoooRequestState>(
      'updates the selected WOOO request',
      setUp: () {
        authenticateSuccessfully();
        when(
          () => updateUseCase.call(any()),
        ).thenAnswer((_) async => const Right<Failure, String>('Updated'));
      },
      build: createUpdateBloc,
      act: (bloc) => bloc.add(updateEvent),
      expect:
          () => [
            const UpdateWoooRequestLoading(),
            const UpdateWoooRequestSuccess('Updated'),
          ],
      verify: (_) {
        final props =
            verify(() => updateUseCase.call(captureAny())).captured.single
                as UpdateWoooProps;
        expect(props.email, 'member@example.com');
        expect(props.userId, 7);
        expect(props.rolePermissionId, 'role-1');
        expect(props.personId, 3);
        expect(props.employeeCode, 'EMP-3');
        expect(props.mobileNumber, '01700000000');
        expect(props.fromDate, updateEvent.fromDate);
        expect(props.toDate, updateEvent.toDate);
        expect(props.rejoiningDate, updateEvent.rejoiningDate);
        expect(props.reason, updateEvent.reason);
        expect(props.woooTypeCode, updateEvent.woooTypeCode);
        expect(props.isHourly, updateEvent.isHourly);
        expect(props.leaveApplicationId, updateEvent.leaveApplicationId);
      },
    );

    blocTest<UpdateWoooRequestBloc, UpdateWoooRequestState>(
      'reports authentication failures without updating a request',
      setUp: failAuthentication,
      build: createUpdateBloc,
      act: (bloc) => bloc.add(updateEvent),
      expect:
          () => [
            const UpdateWoooRequestLoading(),
            const UpdateWoooRequestError('User unavailable'),
          ],
      verify: (_) => verifyNever(() => updateUseCase.call(any())),
    );

    blocTest<UpdateWoooRequestBloc, UpdateWoooRequestState>(
      'reports update failures',
      setUp: () {
        authenticateSuccessfully();
        when(() => updateUseCase.call(any())).thenAnswer(
          (_) async => const Left<Failure, String>(
            ServerFailure(message: 'Update failed'),
          ),
        );
      },
      build: createUpdateBloc,
      act: (bloc) => bloc.add(updateEvent),
      expect:
          () => [
            const UpdateWoooRequestLoading(),
            const UpdateWoooRequestError('Update failed'),
          ],
    );
  });

  group('GetWoooApprovalBloc', () {
    blocTest<GetWoooApprovalBloc, GetWoooApprovalState>(
      'loads approval requests within the selected date range',
      setUp: () {
        authenticateSuccessfully();
        when(() => approvalListUseCase.call(any())).thenAnswer(
          (_) async => Right<Failure, List<WoooDataEntities>>(approvals),
        );
      },
      build: createApprovalListBloc,
      act: (bloc) => bloc.add(approvalListEvent),
      expect:
          () => [GetWoooApprovalLoading(), GetWoooApprovalSuccess(approvals)],
      verify: (_) {
        final props =
            verify(() => approvalListUseCase.call(captureAny())).captured.single
                as GetWoooApprovalProps;
        expect(props.email, 'member@example.com');
        expect(props.userId, 7);
        expect(props.rolePermissionId, 'role-1');
        expect(props.personId, 3);
        expect(props.employeeCode, 'EMP-3');
        expect(props.mobileNumber, '01700000000');
        expect(props.fromDate, fromDate);
        expect(props.toDate, toDate);
      },
    );

    blocTest<GetWoooApprovalBloc, GetWoooApprovalState>(
      'reports authentication failures without loading approvals',
      setUp: failAuthentication,
      build: createApprovalListBloc,
      act: (bloc) => bloc.add(approvalListEvent),
      expect:
          () => [
            GetWoooApprovalLoading(),
            const GetWoooApprovalError('User unavailable'),
          ],
      verify: (_) => verifyNever(() => approvalListUseCase.call(any())),
    );

    blocTest<GetWoooApprovalBloc, GetWoooApprovalState>(
      'reports approval list retrieval failures',
      setUp: () {
        authenticateSuccessfully();
        when(() => approvalListUseCase.call(any())).thenAnswer(
          (_) async => const Left<Failure, List<WoooDataEntities>>(
            ServerFailure(message: 'Approvals unavailable'),
          ),
        );
      },
      build: createApprovalListBloc,
      act: (bloc) => bloc.add(approvalListEvent),
      expect:
          () => [
            GetWoooApprovalLoading(),
            const GetWoooApprovalError('Approvals unavailable'),
          ],
    );
  });

  group('SubmitWoooApprovalBloc', () {
    blocTest<SubmitWoooApprovalBloc, SubmitWoooApprovalState>(
      'submits the approval decision for the authenticated user',
      setUp: () {
        authenticateSuccessfully();
        when(
          () => approvalSubmitUseCase.call(any()),
        ).thenAnswer((_) async => const Right<Failure, String>('Approved'));
      },
      build: createApprovalSubmitBloc,
      act: (bloc) => bloc.add(approvalEvent),
      expect:
          () => [
            const SubmitWoooApprovalLoading(),
            const SubmitWoooApprovalSuccess('Approved'),
          ],
      verify: (_) {
        final props =
            verify(
                  () => approvalSubmitUseCase.call(captureAny()),
                ).captured.single
                as WoooApprovalSubmitUseCaseProps;
        expect(props.email, 'member@example.com');
        expect(props.userId, 7);
        expect(props.rolePermissionId, 'role-1');
        expect(props.personId, 3);
        expect(props.employeeCode, 'EMP-3');
        expect(props.mobileNumber, '01700000000');
        expect(props.status, approvalEvent.status);
        expect(props.employeeWoooId, approvalEvent.employeeWoooId);
      },
    );

    blocTest<SubmitWoooApprovalBloc, SubmitWoooApprovalState>(
      'reports authentication failures without submitting approval',
      setUp: failAuthentication,
      build: createApprovalSubmitBloc,
      act: (bloc) => bloc.add(approvalEvent),
      expect:
          () => [
            const SubmitWoooApprovalLoading(),
            const SubmitWoooApprovalError('User unavailable'),
          ],
      verify: (_) => verifyNever(() => approvalSubmitUseCase.call(any())),
    );

    blocTest<SubmitWoooApprovalBloc, SubmitWoooApprovalState>(
      'reports approval submission failures',
      setUp: () {
        authenticateSuccessfully();
        when(() => approvalSubmitUseCase.call(any())).thenAnswer(
          (_) async => const Left<Failure, String>(
            ServerFailure(message: 'Approval failed'),
          ),
        );
      },
      build: createApprovalSubmitBloc,
      act: (bloc) => bloc.add(approvalEvent),
      expect:
          () => [
            const SubmitWoooApprovalLoading(),
            const SubmitWoooApprovalError('Approval failed'),
          ],
    );
  });
}
