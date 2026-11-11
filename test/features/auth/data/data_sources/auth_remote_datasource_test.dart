import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../../../mock.data/login.data.dart';

class _MockApiService extends Mock implements ApiService {}

Response<dynamic> _response(
  String endpoint, {
  int statusCode = HttpStatus.ok,
  dynamic data,
  Map<String, List<String>> headers = const {},
}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: endpoint),
    statusCode: statusCode,
    data: data,
    headers: Headers.fromMap(headers),
  );
}

void main() {
  late _MockApiService apiService;
  late AuthRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    apiService = _MockApiService();
    dataSource = AuthRemoteDataSourceImpl(apiService: apiService);
  });

  test('login sends encrypted data and parses the user and token', () async {
    when(
      () => apiService.post(ApiUrls.login, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.login,
        data: mockLoginResponse,
        headers: {
          'token': ['session-token'],
        },
      ),
    );

    final result = await dataSource.login('encrypted-login-data');

    expect(result.accessToken, 'session-token');
    expect(result.refreshToken, 'session-token');
    expect(result.user.userId, mockLoginUserModel.userId);
    final body = verify(
      () => apiService.post(ApiUrls.login, data: captureAny(named: 'data')),
    ).captured.single as Map<String, dynamic>;
    expect(body, {'Data': 'encrypted-login-data'});
  });

  test('login rejects an empty response payload with its server message', () {
    when(
      () => apiService.post(ApiUrls.login, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.login,
        data: {'Data': '', 'Message': 'Invalid credentials'},
      ),
    );

    expect(
      dataSource.login('bad-data'),
      throwsA(
        isA<ServerException>().having(
          (exception) => exception.message,
          'message',
          'Invalid credentials',
        ),
      ),
    );
  });

  test('register sends credentials and returns the registration ID', () async {
    when(
      () => apiService.post(ApiUrls.register, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.register,
        statusCode: HttpStatus.created,
        data: {'Data': 'registration-id'},
      ),
    );

    final result = await dataSource.register('user@example.com', 'pass', 'pass');

    expect(result, 'registration-id');
    final body = verify(
      () => apiService.post(ApiUrls.register, data: captureAny(named: 'data')),
    ).captured.single as Map<String, dynamic>;
    expect(body, {
      'UserName': 'user@example.com',
      'password': 'pass',
      'password_confirmation': 'pass',
      'RequestFrom': 'Pashboi',
    });
  });

  test('verify mobile number sends registration status', () async {
    when(
      () => apiService.post(
        ApiUrls.verifyMobileNumber,
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.verifyMobileNumber,
        data: {'Data': 'otp-registration-id'},
      ),
    );

    final result = await dataSource.verifyMobileNumber(
      '+88017000000000',
      true,
    );

    expect(result, 'otp-registration-id');
    final body =
        verify(
              () => apiService.post(
                ApiUrls.verifyMobileNumber,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, {
      'MobileNo': '+88017000000000',
      'IsRegistered': true,
      'RequestFrom': 'Pashboi',
    });
  });

  test('verify OTP sends registration ID, value, and mobile', () async {
    when(
      () => apiService.post(ApiUrls.verifyOTP, data: any(named: 'data')),
    ).thenAnswer(
      (_) async =>
          _response(ApiUrls.verifyOTP, data: {'Data': 'verified'}),
    );

    final result = await dataSource.verifyOtp(
      'registration-id',
      '123456',
      '+88017000000000',
    );

    expect(result, 'verified');
    final body = verify(
      () => apiService.post(ApiUrls.verifyOTP, data: captureAny(named: 'data')),
    ).captured.single as Map<String, dynamic>;
    expect(body, {
      'OTPRegId': 'registration-id',
      'OTPValue': '123456',
      'MobileNumber': '+88017000000000',
      'RequestFrom': 'Pashboi',
    });
  });

  test('reset password sends mobile and password', () async {
    when(
      () => apiService.post(ApiUrls.resetPassword, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(ApiUrls.resetPassword, data: {'Data': 'updated'}),
    );

    final result = await dataSource.resetPassword(
      mobileNumber: '+88017000000000',
      password: 'new-password',
    );

    expect(result, 'updated');
    final body = verify(
      () => apiService.post(
        ApiUrls.resetPassword,
        data: captureAny(named: 'data'),
      ),
    ).captured.single as Map<String, dynamic>;
    expect(body, {
      'MobileNumber': '+88017000000000',
      'Password': 'new-password',
      'RequestFrom': 'Pashboi',
    });
  });
}
