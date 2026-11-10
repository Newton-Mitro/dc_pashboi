import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/fetch_remote_result.dart';
import 'package:pashboi/features/public/pages/data/models/page_model.dart';
import 'package:pashboi/features/public/pages/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/pages/domain/enities/page_entity.dart';
import 'package:pashboi/features/public/pages/domain/repositories/page_repository.dart';
import 'package:pashboi/features/public/pages/domain/usecases/fetch_page_usecase.dart';

class PageRepositoryImpl implements PageRepository {
  final PageRemoteDataSource pageRemoteDataSource;

  PageRepositoryImpl({required this.pageRemoteDataSource});

  @override
  ResultFuture<PageEntity> findPageByPageSlug(PageProps props) async {
    return fetchRemoteResult<PageModel, PageEntity>(
      () => pageRemoteDataSource.fetchPageDataByPageSlug(props),
    );
  }
}
