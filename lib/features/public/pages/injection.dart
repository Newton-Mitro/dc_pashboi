import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/pages/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/pages/data/repositories/page_repository_impl.dart';
import 'package:pashboi/features/public/pages/domain/repositories/page_repository.dart';
import 'package:pashboi/features/public/pages/domain/usecases/fetch_page_usecase.dart';
import 'package:pashboi/features/public/pages/presentation/bloc/page_bloc.dart';

void registerPageModule() {
  // Register Data Sources
  sl.registerLazySingleton<PageRemoteDataSource>(
    () => PageRemoteDataSourceImpl(productApiService: sl<ProductApiService>()),
  );
  // Register Repository
  sl.registerLazySingleton<PageRepository>(
    () => PageRepositoryImpl(pageRemoteDataSource: sl<PageRemoteDataSource>()),
  );

  // Register Use Cases
  sl.registerLazySingleton<PageUseCase>(
    () => PageUseCase(pageRepository: sl<PageRepository>()),
  );

  // Register Bloc

  sl.registerFactory<PageBloc>(() => PageBloc(pageUseCase: sl<PageUseCase>()));
}
