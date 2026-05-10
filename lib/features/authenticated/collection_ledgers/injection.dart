import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/data/repositories/collection_ledger_repository_impl.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/repositories/collection_ledger_repository.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/usecases/fetch_collection_ledgers_usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/presentation/bloc/collection_ledger_bloc.dart';

void registerCollectionLedgerModule() async {
  // Register Data Sources
  sl.registerLazySingleton<CollectionLedgerRemoteDataSource>(
    () => CollectionLedgerRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Repository
  sl.registerLazySingleton<CollectionLedgerRepository>(
    () => CollectionLedgerRepositoryImpl(
      collectionLedgerRemoteDataSource: sl<CollectionLedgerRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<FetchCollectionLedgersUseCase>(
    () => FetchCollectionLedgersUseCase(
      collectionLedgerRepository: sl<CollectionLedgerRepository>(),
    ),
  );

  // Register Bloc
  sl.registerFactory<CollectionLedgerBloc>(
    () => CollectionLedgerBloc(
      fetchCollectionLedgersUseCase: sl<FetchCollectionLedgersUseCase>(),
      getAuthUserUseCase: sl<GetAuthUserUseCase>(),
      appLocalizationService: sl<AppLocalizationService>(),
    ),
  );
}
