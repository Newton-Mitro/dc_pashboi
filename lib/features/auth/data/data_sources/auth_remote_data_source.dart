import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/auth/data/models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login(String encryptedData);

  Future<String> register(
    String email,
    String password,
    String confirmPassword,
  );

  Future<String> verifyMobileNumber(String mobileNumber, bool isRegistered);

  Future<String> verifyOtp(
    String otpRegId,
    String otpValue,
    String mobileNumber,
  );

  Future<String> resetPassword({
    required String mobileNumber,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<AuthUserModel> login(String encryptedData) async {
    try {
      final body = <String, dynamic>{'Data': encryptedData};
      final response = await apiService.post(ApiUrls.login, data: body);

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        if (dataString == null || dataString.isEmpty) {
          if (errorMessage != null) {
            throw ServerException(message: errorMessage);
          } else {
            throw ServerException(message: 'Invalid response format');
          }
        }

        final token = response.headers['token']?.first;

        final jsonResponse = JsonUtil.decodeModelList(dataString);

        final userModel = AuthUserModel.fromJson({
          "user": jsonResponse[0],
          "access_token": token,
          "refresh_token": token,
        });

        return userModel;
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.register,
        data: {
          'UserName': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'RequestFrom': 'Pashboi',
        },
      );

      if (response.statusCode == HttpStatus.created) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        if (dataString == null || dataString.isEmpty) {
          if (errorMessage != null) {
            throw ServerException(message: errorMessage);
          } else {
            throw ServerException(message: 'Invalid response format');
          }
        }

        return dataString;
      } else {
        throw Exception(
          'Registration failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyMobileNumber(
    String mobileNumber,
    bool isRegistered,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.verifyMobileNumber,
        data: {
          'MobileNo': mobileNumber,
          'IsRegistered': isRegistered,
          'RequestFrom': 'Pashboi',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        if (dataString == null || dataString.isEmpty) {
          if (errorMessage != null) {
            throw ServerException(message: errorMessage);
          } else {
            throw ServerException(message: 'Invalid response format');
          }
        }

        return dataString;
      } else {
        throw Exception(
          'Registration failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyOtp(
    String otpRegId,
    String otpValue,
    String mobileNumber,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.verifyOTP,
        data: {
          'OTPRegId': otpRegId,
          'OTPValue': otpValue,
          'MobileNumber': mobileNumber,
          'RequestFrom': 'Pashboi',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        if (dataString == null || dataString.isEmpty) {
          if (errorMessage != null) {
            throw ServerException(message: errorMessage);
          } else {
            throw ServerException(message: 'Invalid response format');
          }
        }

        return dataString;
      } else {
        throw Exception(
          'Registration failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> resetPassword({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        ApiUrls.resetPassword,
        data: {
          'MobileNumber': mobileNumber,
          'Password': password,
          'RequestFrom': 'Pashboi',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        if (dataString == null || dataString.isEmpty) {
          if (errorMessage != null) {
            throw ServerException(message: errorMessage);
          } else {
            throw ServerException(message: 'Invalid response format');
          }
        }

        return dataString;
      } else {
        throw Exception(
          'Registration failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
