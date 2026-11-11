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
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/today_punch_entity.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/todays_punch/bloc/today_punch_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockTodayPunchUseCase extends Mock implements TodayPunchUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockTodayPunchUseCase todayPunchUseCase;
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
  const request = TodayPunchProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-01',
    toDate: '2025-06-30',
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(request);
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    todayPunchUseCase = _MockTodayPunchUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer((invocation) {
      final key = invocation.positionalArguments.single as String;
      return key == 'failed_to_load_user_info'
          ? 'Unable to load current user'
          : key;
    });
  });

  TodayPunchBloc createBloc() => TodayPunchBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    todayPunchUseCase: todayPunchUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<TodayPunchBloc, TodayPunchState>(
    'fetches punch history with the authenticated employee and date range',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(() => todayPunchUseCase.call(any())).thenAnswer(
        (_) async => const Right<Failure, List<TodayPunchEntity>>([]),
      );
    },
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const TodayPunchHistory(fromDate: '2025-06-01', toDate: '2025-06-30'),
        ),
    expect: () => [const TodayPunchLoading(), const TodayPunchSuccess([])],
    verify: (_) {
      final captured =
          verify(() => todayPunchUseCase.call(captureAny())).captured.single
              as TodayPunchProps;
      expect(captured, request);
    },
  );

  blocTest<TodayPunchBloc, TodayPunchState>(
    'shows an error when the authenticated user cannot be loaded',
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
          const TodayPunchHistory(fromDate: '2025-06-01', toDate: '2025-06-30'),
        ),
    expect:
        () => [
          const TodayPunchLoading(),
          const TodayPunchError('Unable to load current user'),
        ],
    verify: (_) => verifyNever(() => todayPunchUseCase.call(any())),
  );
}
