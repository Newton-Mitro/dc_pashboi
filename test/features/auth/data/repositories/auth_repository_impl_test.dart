import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:pashboi/features/auth/data/models/auth_user_model.dart';
import 'package:pashboi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import '../../../../mock.data/login.data.dart';

class _MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockLocalDataSource extends Mock implements AuthLocalDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late _MockLocalDataSource local;
  late AuthRepositoryImpl repository;

  final authUser = AuthUserModel(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    user: mockLoginUserModel,
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    local = _MockLocalDataSource();
    repository = AuthRepositoryImpl(
      authRemoteDataSource: remote,
      authLocalDataSource: local,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('login persists the returned user and returns it', () async {
    when(() => remote.login('encrypted')).thenAnswer((_) async => authUser);
    when(() => local.setAuthUser(authUser)).thenAnswer((_) async {});

    final result = await repository.login('encrypted');

    expect(result, Right<Failure, AuthUserEntity>(authUser));
    verify(() => remote.login('encrypted')).called(1);
    verify(() => local.setAuthUser(authUser)).called(1);
  });

  test('login maps remote exceptions to failures', () async {
    when(
      () => remote.login('encrypted'),
    ).thenThrow(ServerException(message: 'Login unavailable'));

    final result = await repository.login('encrypted');

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Login unavailable',
      ),
    );
    verifyNever(() => local.setAuthUser(authUser));
  });

  test('registration delegates all credentials', () async {
    when(
      () => remote.register('user@example.com', 'password', 'confirmation'),
    ).thenAnswer((_) async => 'registered');

    final result = await repository.register(
      'user@example.com',
      'password',
      'confirmation',
    );

    expect(result, const Right<Failure, String>('registered'));
    verify(
      () => remote.register('user@example.com', 'password', 'confirmation'),
    ).called(1);
  });

  test('logout clears persisted credentials', () async {
    when(() => local.clearAuthUser()).thenAnswer((_) async {});

    final result = await repository.logout();

    expect(result, const Right<Failure, void>(null));
    verify(() => local.clearAuthUser()).called(1);
  });

  test('getAuthUser returns the stored auth user', () async {
    when(() => local.getAuthUser()).thenAnswer((_) async => authUser);

    final result = await repository.getAuthUser();

    expect(result, Right<Failure, AuthUserEntity>(authUser));
  });

  test('getAuthUser maps a missing cache entry to CacheFailure', () async {
    when(
      () => local.getAuthUser(),
    ).thenThrow(CacheException(message: 'No user'));

    final result = await repository.getAuthUser();

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<CacheFailure>().having((failure) => failure.message, 'message', 'No user'),
    );
  });

  test('mobile verification saves the verified mobile number', () async {
    when(
      () => remote.verifyMobileNumber('+88017000000000', true),
    ).thenAnswer((_) async => 'otp-registration-id');
    when(() => local.setRegisteredMobile('+88017000000000')).thenAnswer(
      (_) async {},
    );

    final result = await repository.verifyMobileNumber(
      '+88017000000000',
      true,
    );

    expect(result, const Right<Failure, String>('otp-registration-id'));
    verify(() => local.setRegisteredMobile('+88017000000000')).called(1);
  });

  test('OTP verification delegates all values', () async {
    when(
      () => remote.verifyOtp('registration-id', '123456', '+88017000000000'),
    ).thenAnswer((_) async => 'verified');

    final result = await repository.verifyOtp(
      'registration-id',
      '123456',
      '+88017000000000',
    );

    expect(result, const Right<Failure, String>('verified'));
  });

  test('registered mobile is read from local storage', () async {
    when(
      () => local.getRegisteredMobile(),
    ).thenAnswer((_) async => '+88017000000000');

    final result = await repository.getRegisteredMobile();

    expect(result, const Right<Failure, String>('+88017000000000'));
  });

  test('password reset delegates the mobile and new password', () async {
    when(
      () => remote.resetPassword(
        mobileNumber: '+88017000000000',
        password: 'new-password',
      ),
    ).thenAnswer((_) async => 'updated');

    final result = await repository.resetPassword(
      mobileNumber: '+88017000000000',
      password: 'new-password',
    );

    expect(result, const Right<Failure, String>('updated'));
  });
}
