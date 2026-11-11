import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/attendance_calender/bloc/attendance_calender_bloc.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/attendance_calender/bloc/attendance_calender_event.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockAttendanceUseCase extends Mock implements AttendanceUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockAttendanceUseCase attendanceUseCase;
  late _MockLocalizationService localizationService;

  final user = UserEntity(
    userId: 7,
    personId: 3,
    loginEmail: 'member@example.com',
    roleId: 'role-1',
    roleName: 'Member',
    userName: 'Member',
    branchCode: '01',
    regMobile: '01700000000',
    address: '',
    organizationCode: '',
    deviceId: 1,
    employeeCode: 'EMP-3',
    isNewMenu: false,
    rolePermissions: const [],
  );
  final authUser = AuthUserEntity(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    user: user,
  );
  final attendance = <GetAttendanceEntities>[];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const AttendanceProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
        fromDate: '',
        toDate: '',
      ),
    );
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    attendanceUseCase = _MockAttendanceUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  AttendanceCalenderBloc createBloc() => AttendanceCalenderBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    attendanceUseCase: attendanceUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<AttendanceCalenderBloc, AttendanceCalenderState>(
    'fetches the requested date range with the current employee context',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(() => attendanceUseCase.call(any())).thenAnswer(
        (_) async => Right<Failure, List<GetAttendanceEntities>>(attendance),
      );
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const AttendanceCalenderHistory(
            fromDate: '2025-06-01',
            toDate: '2025-06-30',
          ),
        ),
    expect:
        () => [
          const AttendanceCalenderLoading(),
          AttendanceCalenderSuccess(attendance),
        ],
    verify: (_) {
      final props =
          verify(() => attendanceUseCase.call(captureAny())).captured.single
              as AttendanceProps;
      expect(props.fromDate, '2025-06-01');
      expect(props.toDate, '2025-06-30');
      expect(props.email, user.loginEmail);
      expect(props.employeeCode, user.employeeCode);
    },
  );

  blocTest<AttendanceCalenderBloc, AttendanceCalenderState>(
    'reports authentication errors without requesting attendance history',
    setUp: () {
      when(() => getAuthUserUseCase.call(any())).thenAnswer(
        (_) async => Left<Failure, AuthUserEntity>(
          const ServerFailure(message: 'User unavailable'),
        ),
      );
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const AttendanceCalenderHistory(
            fromDate: '2025-06-01',
            toDate: '2025-06-30',
          ),
        ),
    expect:
        () => [
          AttendanceCalenderLoading(),
          AttendanceCalenderError('failed_to_load_user_info'),
        ],
    verify: (_) => verifyNever(() => attendanceUseCase.call(any())),
  );

  blocTest<AttendanceCalenderBloc, AttendanceCalenderState>(
    'reports attendance retrieval failures',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(() => attendanceUseCase.call(any())).thenAnswer(
        (_) async => Left<Failure, List<GetAttendanceEntities>>(
          const ServerFailure(message: 'Attendance unavailable'),
        ),
      );
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const AttendanceCalenderHistory(
            fromDate: '2025-06-01',
            toDate: '2025-06-30',
          ),
        ),
    expect:
        () => [
          AttendanceCalenderLoading(),
          AttendanceCalenderError('Attendance unavailable'),
        ],
  );
}
