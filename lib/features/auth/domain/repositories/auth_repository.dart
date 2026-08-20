import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  ResultFuture<String> register(
    String email,
    String password,
    String confirmPassword,
  );
  ResultFuture<AuthUserEntity> login(String encryptedData);
  ResultFuture<void> logout();
  ResultFuture<AuthUserEntity> getAuthUser();

  ResultFuture<String> verifyMobileNumber(
    String mobileNumber,
    bool isRegistered,
  );

  ResultFuture<String> verifyOtp(
    String otpRegId,
    String otpValue,
    String mobileNumber,
  );

  ResultFuture<String> resetPassword({
    required String mobileNumber,
    required String password,
  });

  ResultFuture<String> getRegisteredMobile();
}
