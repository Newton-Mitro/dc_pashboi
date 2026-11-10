import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/fetch_remote_result.dart';
import 'package:pashboi/features/public/notice/data/data_sources/remote_notice_datasource.dart';
import 'package:pashboi/features/public/notice/domain/enities/notice_entity.dart';
import 'package:pashboi/features/public/notice/domain/repositories/notice_repository.dart';
import 'package:pashboi/features/public/notice/data/models/notice_model.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;

  NoticeRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<NoticeEntity>> findNotice() async {
    return fetchRemoteResult<List<NoticeModel>, List<NoticeEntity>>(
      remoteDataSource.findNotice,
    );
  }
}
