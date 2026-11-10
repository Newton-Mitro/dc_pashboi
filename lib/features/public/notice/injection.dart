import 'package:pashboi/core/injection.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/notice/data/data_sources/remote_notice_datasource.dart';
import 'package:pashboi/features/public/notice/data/repositories/notice_repository_impl.dart';
import 'package:pashboi/features/public/notice/domain/repositories/notice_repository.dart';
import 'package:pashboi/features/public/notice/domain/usecases/fetch_notice_usecase.dart';
import 'package:pashboi/features/public/notice/presentation/bloc/notice_bloc.dart';

void registerNoticeModule() async {
  sl.registerLazySingleton<NoticeRemoteDataSource>(
    () =>
        NoticeRemoteDataSourceImpl(productApiService: sl<ProductApiService>()),
  );

  sl.registerLazySingleton<NoticeRepository>(
    () => NoticeRepositoryImpl(remoteDataSource: sl<NoticeRemoteDataSource>()),
  );

  sl.registerLazySingleton<NoticeUseCase>(
    () => NoticeUseCase(noticeRepository: sl<NoticeRepository>()),
  );

  sl.registerFactory<NoticeBloc>(
    () => NoticeBloc(noticeUseCase: sl<NoticeUseCase>()),
  );
}
