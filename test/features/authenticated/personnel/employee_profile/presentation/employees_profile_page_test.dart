import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
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
import 'package:pashboi/features/authenticated/personnel/employee_profile/presentation/pages/employee_profile_page/employees_profile_page.dart';
import 'package:pashboi/shared/widgets/theme_selector/bloc/theme_selector_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockEmployeeDetailsUseCase extends Mock
    implements EmployeeDetailsUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

class _MockThemeSelectorBloc
    extends MockBloc<ThemeSelectorEvent, ThemeSelectorState>
    implements ThemeSelectorBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockEmployeeDetailsUseCase employeeDetailsUseCase;
  late _MockLocalizationService localizationService;
  late _MockThemeSelectorBloc themeBloc;

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
    employeeCode: 'EMP-7',
    isNewMenu: false,
    rolePermissions: const [],
  );
  late AuthUserEntity authUser;

  setUpAll(() async {
    await Locales.init(['en', 'bn']);
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const EmployeeDetailsProps(
        email: '',
        userId: 0,
        rolePermissionId: '',
        personId: 0,
        employeeCode: '',
        mobileNumber: '',
      ),
    );
  });

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    employeeDetailsUseCase = _MockEmployeeDetailsUseCase();
    localizationService = _MockLocalizationService();
    themeBloc = _MockThemeSelectorBloc();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
    authUser = AuthUserEntity(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      user: user,
    );
    whenListen(
      themeBloc,
      const Stream<ThemeSelectorState>.empty(),
      initialState: BlueOceanTheme(),
    );
  });

  Widget buildPage(EmployeesProfileBloc profileBloc) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeesProfileBloc>.value(value: profileBloc),
        BlocProvider<ThemeSelectorBloc>.value(value: themeBloc),
      ],
      child: MaterialApp(
        supportedLocales: const [Locale('en', 'US'), Locale('bn', 'BD')],
        localizationsDelegates: Locales.delegates,
        locale: const Locale('en', 'US'),
        home: const EmployeesProfilePage(),
      ),
    );
  }

  testWidgets('requests employee details and displays the loading state', (
    tester,
  ) async {
    final employeeCompleter =
        Completer<Either<Failure, EmployeeDetailsEntity>>();
    when(
      () => getAuthUserUseCase.call(any()),
    ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
    when(
      () => employeeDetailsUseCase.call(any()),
    ).thenAnswer((_) => employeeCompleter.future);
    final bloc = EmployeesProfileBloc(
      getAuthUserUseCase: getAuthUserUseCase,
      employeeDetailsUseCase: employeeDetailsUseCase,
      appLocalizationService: localizationService,
    );
    addTearDown(() async {
      if (!employeeCompleter.isCompleted) {
        employeeCompleter.complete(
          Left<Failure, EmployeeDetailsEntity>(
            const ServerFailure(message: 'Profile unavailable'),
          ),
        );
      }
      await bloc.close();
      await themeBloc.close();
    });

    await tester.pumpWidget(buildPage(bloc));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(() => employeeDetailsUseCase.call(any())).called(1);

    employeeCompleter.complete(
      Right<Failure, EmployeeDetailsEntity>(
        EmployeeDetailsModel.fromJson({
          'EmployeeId': 7,
          'FullName': 'Alex Member',
          'PersonPhoto': 'N/A',
        }),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Alex Member'), findsOneWidget);
  });

  testWidgets('shows an employee profile and fallback image placeholder', (
    tester,
  ) async {
    final employee = EmployeeDetailsModel.fromJson({
      'EmployeeId': 7,
      'FullName': 'Alex Member',
      'PersonPhoto': 'N/A',
      'DesignationName': 'Officer',
      'DepartmentName': 'Operations',
      'EmployeeCategoryName': 'General Staff',
      'SupervisorName': 'Jordan Manager',
      'EmployeeCode': 'EMP-7',
      'Gender': 'Other',
      'EmployeeEmail': 'alex.work@example.com',
      'Email': 'alex@example.com',
      'JoiningDate': '2020-01-01',
      'BloodGroup': 'O+',
      'NID': 'NID-7',
      'MobileNumber': '01700000000',
    });
    when(
      () => getAuthUserUseCase.call(any()),
    ).thenAnswer((_) async => Right<Failure, AuthUserEntity>(authUser));
    when(
      () => employeeDetailsUseCase.call(any()),
    ).thenAnswer((_) async => Right<Failure, EmployeeDetailsEntity>(employee));
    final bloc = EmployeesProfileBloc(
      getAuthUserUseCase: getAuthUserUseCase,
      employeeDetailsUseCase: employeeDetailsUseCase,
      appLocalizationService: localizationService,
    );
    addTearDown(() async {
      await bloc.close();
      await themeBloc.close();
    });

    await tester.pumpWidget(buildPage(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Alex Member'), findsOneWidget);
    expect(find.text('Officer'), findsOneWidget);
    expect(find.text('Operations'), findsOneWidget);
    expect(find.text('General Staff'), findsOneWidget);
    expect(find.text('EMP-7'), findsOneWidget);
    expect(find.text('alex.work@example.com'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows profile loading errors', (tester) async {
    when(() => getAuthUserUseCase.call(any())).thenAnswer(
      (_) async => Left<Failure, AuthUserEntity>(
        const ServerFailure(message: 'Profile unavailable'),
      ),
    );
    final bloc = EmployeesProfileBloc(
      getAuthUserUseCase: getAuthUserUseCase,
      employeeDetailsUseCase: employeeDetailsUseCase,
      appLocalizationService: localizationService,
    );
    addTearDown(() async {
      await bloc.close();
      await themeBloc.close();
    });

    await tester.pumpWidget(buildPage(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Profile unavailable'), findsOneWidget);
  });
}
