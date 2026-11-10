import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/service_centers/data/data_source/remort_service_center_datasource.dart';
import 'package:pashboi/features/public/service_centers/data/repositories/service_center_repository_impl.dart';
import 'package:pashboi/features/public/service_centers/domain/repositories/service_center_repository.dart';
import 'package:pashboi/features/public/service_centers/domain/usecase/fetch_service_center_usecase.dart';
import 'package:pashboi/features/public/service_centers/presentation/bloc/service_center_bloc.dart';

void registerServiceCenterModule() {
  sl.registerLazySingleton<ServiceCenterRemoteDataSource>(
    () => ServiceCenterRemoteDataSourceImpl(
      productApiService: sl<ProductApiService>(),
    ),
  );
  sl.registerLazySingleton<ServiceCenterRepository>(
    () => ServiceCenterRepositoryImpl(
      remoteDataSource: sl<ServiceCenterRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<FetchServiceCenterUseCase>(
    () => FetchServiceCenterUseCase(
      serviceCenterRepository: sl<ServiceCenterRepository>(),
    ),
  );

  sl.registerFactory<ServiceCenterBloc>(
    () => ServiceCenterBloc(
      fetchServiceCenterUseCase: sl<FetchServiceCenterUseCase>(),
    ),
  );
}
