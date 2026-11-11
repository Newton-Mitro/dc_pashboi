import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/core/utils/crypto_helper.dart';
import 'package:pashboi/features/auth/data/models/auth_user_model.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/repositories/auth_repository.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_registered_mobile_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/login_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/logout_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/registration_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/verify_mobile_number_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../../../mock.data/login.data.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  final authUser = AuthUserModel(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    user: mockLoginUserModel,
  );

  setUp(() {
    repository = _MockAuthRepository();
  });

  test('LoginUseCase serializes, encrypts, and submits credentials', () async {
    when(() => repository.login(any())).thenAnswer((_) async => Right(authUser));
    final useCase = LoginUseCase(authRepository: repository);

    final result = await useCase(
      const LoginParams(email: ' user@example.com ', password: ' secret '),
    );

    expect(result, Right<Failure, AuthUserEntity>(authUser));
    final encrypted = verify(() => repository.login(captureAny())).captured.single
        as String;
    expect(encrypted, startsWith('00*'));
    expect(
      jsonDecode(CryptoHelper.decrypt(encrypted.substring(3))),
      {
        'UserName': 'user@example.com',
        'Password': 'secret',
        'RequestFrom': 'MMS',
      },
    );
  });

  test('RegistrationUseCase trims the submitted values', () async {
    when(
      () => repository.register('user@example.com', 'password', 'password'),
    ).thenAnswer((_) async => const Right('registration-id'));

    final result = await RegistrationUseCase(authRepository: repository)(
      RegistrationParams(
        email: ' user@example.com ',
        password: ' password ',
        confirmPassword: ' password ',
      ),
    );

    expect(result, const Right<Failure, String>('registration-id'));
    verify(
      () => repository.register('user@example.com', 'password', 'password'),
    ).called(1);
  });

  test('VerifyMobileNumberUseCase trims the mobile number', () async {
    when(
      () => repository.verifyMobileNumber('+88017000000000', true),
    ).thenAnswer((_) async => const Right('otp-id'));

    final result =
        await VerifyMobileNumberUseCase(authRepository: repository)(
          VerifyMobileNumberParams(
            mobileNumber: ' +88017000000000 ',
            isRegistered: true,
          ),
        );

    expect(result, const Right<Failure, String>('otp-id'));
    verify(
      () => repository.verifyMobileNumber('+88017000000000', true),
    ).called(1);
  });

  test('VerifyOtpUseCase trims the mobile number and forwards OTP values', () async {
    when(
      () => repository.verifyOtp('otp-id', '123456', '+88017000000000'),
    ).thenAnswer((_) async => const Right('verified'));

    final result = await VerifyOtpUseCase(authRepository: repository)(
      VerifyOtpParams(
        otpRegId: 'otp-id',
        otpValue: '123456',
        mobileNumber: ' +88017000000000 ',
      ),
    );

    expect(result, const Right<Failure, String>('verified'));
    verify(
      () => repository.verifyOtp('otp-id', '123456', '+88017000000000'),
    ).called(1);
  });

  test('ResetPasswordUseCase trims the mobile and password', () async {
    when(
      () => repository.resetPassword(
        mobileNumber: '+88017000000000',
        password: 'new-password',
      ),
    ).thenAnswer((_) async => const Right('updated'));

    final result = await ResetPasswordUseCase(authRepository: repository)(
      ResetPasswordParams(
        mobileNumber: ' +88017000000000 ',
        password: ' new-password ',
      ),
    );

    expect(result.isRight(), isTrue);
    verify(
      () => repository.resetPassword(
        mobileNumber: '+88017000000000',
        password: 'new-password',
      ),
    ).called(1);
  });

  test('GetAuthUserUseCase returns the repository result', () async {
    when(() => repository.getAuthUser()).thenAnswer((_) async => Right(authUser));

    final result = await GetAuthUserUseCase(
      authRepository: repository,
    ).call(NoParams());

    expect(result, Right<Failure, AuthUserEntity>(authUser));
    verify(() => repository.getAuthUser()).called(1);
  });

  test('GetRegisteredMobileUseCase returns the repository result', () async {
    when(
      () => repository.getRegisteredMobile(),
    ).thenAnswer((_) async => const Right('+88017000000000'));

    final result = await GetRegisteredMobileUseCase(
      authRepository: repository,
    ).call(NoParams());

    expect(result, const Right<Failure, String>('+88017000000000'));
    verify(() => repository.getRegisteredMobile()).called(1);
  });

  test('LogoutUseCase delegates logout', () async {
    when(() => repository.logout()).thenAnswer((_) async => const Right(null));

    final result = await LogoutUseCase(
      authRepository: repository,
    ).call(NoParams());

    expect(result, const Right<Failure, void>(null));
    verify(() => repository.logout()).called(1);
  });
}
