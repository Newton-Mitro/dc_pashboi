import 'package:dartz/dartz.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<AuthUserEntity> login(String encryptedData) async {
    try {
      final result = await authRemoteDataSource.login(encryptedData);
      await authLocalDataSource.setAuthUser(result);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final result = await authRemoteDataSource.register(
        email,
        password,
        confirmPassword,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await authLocalDataSource.clearAuthUser();
      return const Right(null);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<AuthUserEntity> getAuthUser() async {
    try {
      final user = await authLocalDataSource.getAuthUser();

      return Right(user);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> verifyMobileNumber(
    String mobileNumber,
    bool isRegistered,
  ) async {
    try {
      final result = await authRemoteDataSource.verifyMobileNumber(
        mobileNumber,
        isRegistered,
      );
      await authLocalDataSource.setRegisteredMobile(mobileNumber);
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> verifyOtp(
    String otpRegId,
    String otpValue,
    String mobileNumber,
  ) async {
    try {
      final result = await authRemoteDataSource.verifyOtp(
        otpRegId,
        otpValue,
        mobileNumber,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> getRegisteredMobile() async {
    try {
      final result = await authLocalDataSource.getRegisteredMobile();
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<String> resetPassword({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final result = await authRemoteDataSource.resetPassword(
        mobileNumber: mobileNumber,
        password: password,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
