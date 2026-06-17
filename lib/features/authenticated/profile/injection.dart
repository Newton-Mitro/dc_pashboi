import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/profile/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/profile/data/repositories/profile_repository_impl.dart';
import 'package:pashboi/features/authenticated/profile/domain/repositories/profile_repository.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/change_password_usecase.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/get_profile_usecase.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:pashboi/features/authenticated/profile/presentation/change_password/bloc/change_password_bloc.dart';
import 'package:pashboi/features/authenticated/profile/presentation/profile_page/bloc/profile_bloc.dart';

void registerProfileModule() async {
  // Register Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileRemoteDataSource: sl<ProfileRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(profileRepository: sl<ProfileRepository>()),
  );

  sl.registerLazySingleton<UpdateProfileImageUseCase>(
    () => UpdateProfileImageUseCase(profileRepository: sl<ProfileRepository>()),
  );

  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(profileRepository: sl<ProfileRepository>()),
  );

  // Register Bloc
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl<GetProfileUseCase>(),
      updateProfileImageUseCase: sl<UpdateProfileImageUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<ChangePasswordBloc>(
    () => ChangePasswordBloc(
      changePasswordUseCase: sl<ChangePasswordUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
