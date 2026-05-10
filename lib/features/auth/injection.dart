import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/local_storage/local_storage.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:pashboi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pashboi/features/auth/domain/repositories/auth_repository.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_registered_mobile_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/login_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/logout_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/registration_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/verify_mobile_number_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:pashboi/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/mobile_number_verification_bloc/mobile_number_verification_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/otp_verification_bloc/otp_verification_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/registration_page_bloc/registration_page_bloc.dart';
import 'package:pashboi/features/auth/presentation/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:pashboi/features/authenticated/authenticated_shared/bloc/authenticated_home_bloc.dart';

void registerAuthModule() async {
  // Register Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(localStorage: sl<LocalStorage>()),
  );

  // Register Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
      authLocalDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegistrationUseCase>(
    () => RegistrationUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetAuthUserUseCase>(
    () => GetAuthUserUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyMobileNumberUseCase>(
    () => VerifyMobileNumberUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(authRepository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetRegisteredMobileUseCase>(
    () => GetRegisteredMobileUseCase(authRepository: sl<AuthRepository>()),
  );
  // Register Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<RegistrationPageBloc>(
    () => RegistrationPageBloc(
      registrationUseCase: sl<RegistrationUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<AuthenticatedHomeBloc>(() => AuthenticatedHomeBloc());

  sl.registerFactory<VerifyMobileNumberBloc>(
    () => VerifyMobileNumberBloc(
      verifyMobileNumberUseCase: sl<VerifyMobileNumberUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<OtpVerificationBloc>(
    () => OtpVerificationBloc(
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      getRegisteredMobileUseCase: sl<GetRegisteredMobileUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
