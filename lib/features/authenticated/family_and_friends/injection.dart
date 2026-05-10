import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/datasources/family_and_friend_remote.datasource.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/datasources/relationship_remote_datasource.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/repositories/family_and_friend_repository.impl.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/repositories/relationship_repository_impl.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/repositories/family_and_friend_repository.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/repositories/relationship_repository.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/add_family_and_friend_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/fetch_relationships_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/get_family_and_friends_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/add_family_and_relative_bloc/add_family_and_relative_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/family_and_relatives_bloc/family_and_relatives_bloc.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/relationship_bloc/relationship_bloc.dart';

void registerFamilyAndFriendsModule() async {
  // Register Data Sources
  sl.registerLazySingleton<FamilyAndFriendRemoteDataSource>(
    () => FamilyAndFriendRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );
  sl.registerLazySingleton<RelationshipRemoteDataSource>(
    () => RelationshipRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<FamilyAndFriendRepository>(
    () => FamilyAndFriendRepositoryImpl(
      familyAndFriendRemoteDataSource: sl<FamilyAndFriendRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<RelationshipRepository>(
    () => RelationshipRepositoryImpl(
      relationshipRemoteDataSource: sl<RelationshipRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetFamilyAndFriendsUseCase>(
    () => GetFamilyAndFriendsUseCase(
      familyAndFriendRepository: sl<FamilyAndFriendRepository>(),
    ),
  );
  sl.registerLazySingleton<FetchRelationshipsUseCase>(
    () => FetchRelationshipsUseCase(
      relationshipRepository: sl<RelationshipRepository>(),
    ),
  );
  sl.registerLazySingleton<AddFamilyAndFriendUsecase>(
    () => AddFamilyAndFriendUsecase(
      familyAndFriendRepository: sl<FamilyAndFriendRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<FamilyAndRelativesBloc>(
    () => FamilyAndRelativesBloc(
      getFamilyAndFriendsUseCase: sl<GetFamilyAndFriendsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<RelationshipBloc>(
    () => RelationshipBloc(
      fetchRelationshipsUseCase: sl<FetchRelationshipsUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );

  sl.registerFactory<AddFamilyAndRelativeBloc>(
    () => AddFamilyAndRelativeBloc(
      addFamilyAndFriendUseCase: sl<AddFamilyAndFriendUsecase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
