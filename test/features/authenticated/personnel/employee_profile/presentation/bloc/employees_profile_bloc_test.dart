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
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/models/employee_details_model.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/entities/employee_details_entity.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/presentation/pages/employee_profile_page/bloc/employees_profile_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockEmployeeDetailsUseCase extends Mock
    implements EmployeeDetailsUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockEmployeeDetailsUseCase employeeDetailsUseCase;
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
  final employee = EmployeeDetailsModel.fromJson({
    'EmployeeId': 7,
    'FullName': 'Member',
    'EmployeeCode': 'EMP-3',
  });
  const props = EmployeeDetailsProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(props);
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    employeeDetailsUseCase = _MockEmployeeDetailsUseCase();
    localizationService = _MockLocalizationService();
  });

  EmployeesProfileBloc createBloc() => EmployeesProfileBloc(
    employeeDetailsUseCase: employeeDetailsUseCase,
    getAuthUserUseCase: getAuthUserUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<EmployeesProfileBloc, EmployeesProfileState>(
    'loads profile details with the authenticated employee context',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(() => employeeDetailsUseCase.call(any())).thenAnswer(
        (_) async => Right<Failure, EmployeeDetailsEntity>(employee),
      );
    },
    build: createBloc,
    act: (bloc) => bloc.add(const FetchEmployeeDetailsEvent()),
    expect:
        () => [
          const EmployeesProfileLoading(),
          EmployeesProfileLoaded(employee),
        ],
    verify: (_) {
      final captured =
          verify(
                () => employeeDetailsUseCase.call(captureAny()),
              ).captured.single
              as EmployeeDetailsProps;
      expect(captured, props);
    },
  );

  blocTest<EmployeesProfileBloc, EmployeesProfileState>(
    'reports authentication failures without requesting profile details',
    setUp: () {
      when(() => getAuthUserUseCase.call(any())).thenAnswer(
        (_) async => Left<Failure, AuthUserEntity>(
          const ServerFailure(message: 'User unavailable'),
        ),
      );
    },
    build: createBloc,
    act: (bloc) => bloc.add(const FetchEmployeeDetailsEvent()),
    expect:
        () => [
          const EmployeesProfileLoading(),
          const EmployeesProfileError('User unavailable'),
        ],
    verify: (_) => verifyNever(() => employeeDetailsUseCase.call(any())),
  );

  blocTest<EmployeesProfileBloc, EmployeesProfileState>(
    'reports profile retrieval failures',
    setUp: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
      when(() => employeeDetailsUseCase.call(any())).thenAnswer(
        (_) async => Left<Failure, EmployeeDetailsEntity>(
          const ServerFailure(message: 'Profile unavailable'),
        ),
      );
    },
    build: createBloc,
    act: (bloc) => bloc.add(const FetchEmployeeDetailsEvent()),
    expect:
        () => [
          const EmployeesProfileLoading(),
          const EmployeesProfileError('Profile unavailable'),
        ],
  );
}
