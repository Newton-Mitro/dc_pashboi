import 'dart:convert';

import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/core/utils/crypto_helper.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/repositories/auth_repository.dart';

final class LoginParams {
  final String email;
  final String password;
  final String requestFrom = 'MMS';

  const LoginParams({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'UserName': email.trim(),
      'Password': password.trim(),
      'RequestFrom': requestFrom.trim(),
    };
  }
}

class LoginUseCase extends UseCase<AuthUserEntity, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  @override
  ResultFuture<AuthUserEntity> call(LoginParams params) async {
    // Convert login data to JSON string
    final jsonString = jsonEncode(params.toJson());

    // Encrypt JSON
    final encryptedData = CryptoHelper.encrypt(jsonString);

    // Send encrypted data to repository
    return await authRepository.login(encryptedData);
  }
}
