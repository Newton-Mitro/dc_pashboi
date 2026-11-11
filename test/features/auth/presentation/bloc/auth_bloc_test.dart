import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/core/utils/crypto_helper.dart';
import 'package:pashboi/features/auth/data/models/auth_user_model.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/login_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/logout_usecase.dart';
import 'package:pashboi/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import '../../../../mock.data/login.data.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockLoginUseCase loginUseCase;
  late _MockLogoutUseCase logoutUseCase;
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockLocalizationService localizationService;

  final authUser = AuthUserModel(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    user: mockLoginUserModel,
  );

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    logoutUseCase = _MockLogoutUseCase();
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer((invocation) {
      return invocation.positionalArguments.single as String;
    });
  });

  AuthBloc createBloc() => AuthBloc(
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
    getAuthUserUseCase: getAuthUserUseCase,
    appLocalizationService: localizationService,
  );

  group('login validation', () {
    blocTest<AuthBloc, AuthState>(
      'reports required username and password without calling login',
      build: createBloc,
      act:
          (bloc) => bloc.add(const LoginRequested(username: '', password: ' ')),
      expect:
          () => [
            const AuthValidationErrorState({
              'email': 'email_required',
              'password': 'password_required',
            }),
          ],
      verify: (_) => verifyNever(() => loginUseCase.call(any())),
    );

    blocTest<AuthBloc, AuthState>(
      'rejects malformed email before invoking login',
      build: createBloc,
      act:
          (bloc) => bloc.add(
            const LoginRequested(
              username: 'not-an-email',
              password: 'password',
            ),
          ),
      expect:
          () => [
            const AuthValidationErrorState({'email': 'valid_email_required'}),
          ],
      verify: (_) => verifyNever(() => loginUseCase.call(any())),
    );
  });

  blocTest<AuthBloc, AuthState>(
    'hashes the password and emits authenticated on successful login',
    build: () {
      when(
        () => loginUseCase.call(any()),
      ).thenAnswer((_) async => Right(authUser));
      return createBloc();
    },
    act:
        (bloc) => bloc.add(
          const LoginRequested(
            username: 'user@example.com',
            password: 'secret-password',
          ),
        ),
    expect: () => [const AuthLoading(), Authenticated(authUser)],
    verify: (_) {
      final params =
          verify(() => loginUseCase.call(captureAny())).captured.single
              as LoginParams;
      expect(params.email, 'user@example.com');
      expect(params.password, CryptoHelper.md5Hash('secret-password'));
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits field validation errors returned by the login use case',
    build: () {
      when(() => loginUseCase.call(any())).thenAnswer(
        (_) async =>
            const Left(ValidationFailure(errors: {'password': 'incorrect'})),
      );
      return createBloc();
    },
    act:
        (bloc) => bloc.add(
          const LoginRequested(
            username: 'user@example.com',
            password: 'secret',
          ),
        ),
    expect:
        () => [
          const AuthLoading(),
          const AuthValidationErrorState({'password': 'incorrect'}),
        ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits an authentication error when login fails',
    build: () {
      when(() => loginUseCase.call(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Service unavailable')),
      );
      return createBloc();
    },
    act:
        (bloc) => bloc.add(
          const LoginRequested(
            username: 'user@example.com',
            password: 'secret',
          ),
        ),
    expect: () => [const AuthLoading(), const AuthError('Service unavailable')],
  );

  blocTest<AuthBloc, AuthState>(
    'clears the session and emits unauthenticated on logout',
    build: () {
      when(
        () => logoutUseCase.call(any()),
      ).thenAnswer((_) async => const Right(null));
      return createBloc();
    },
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => [const AuthLoading(), const UnAuthenticated()],
    verify: (_) => verify(() => logoutUseCase.call(any())).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'restores an authenticated user when a saved session exists',
    build: () {
      when(
        () => getAuthUserUseCase.call(any()),
      ).thenAnswer((_) async => Right(authUser));
      return createBloc();
    },
    act: (bloc) => bloc.add(const AuthUserCheck()),
    expect: () => [const AuthLoading(), Authenticated(authUser)],
    verify: (_) => verify(() => getAuthUserUseCase.call(any())).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'emits unauthenticated when no saved session can be restored',
    build: () {
      when(() => getAuthUserUseCase.call(any())).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'No saved session')),
      );
      return createBloc();
    },
    act: (bloc) => bloc.add(const AuthUserCheck()),
    expect: () => [const AuthLoading(), const UnAuthenticated()],
  );
}
