import 'package:dartz/dartz.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/failure_mapper.dart';
import 'package:pashboi/features/my_app/data/data_source/app_status_remote_datasource.dart';
import 'package:pashboi/features/my_app/domain/entities/advertisement_entity.dart';
import 'package:pashboi/features/my_app/domain/entities/app_status_entity.dart';
import 'package:pashboi/features/my_app/domain/repositories/app_status_repository.dart';

class AppStatusRepositoryImpl implements AppStatusRepository {
  final AppStatusRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppStatusRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<AppStatusEntity> fetchAppStatus(int varsion) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(FailureMapper.fromException(NoInternetFailure()));
      }

      final result = await remoteDataSource.getAppStatus(varsion);

      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  ResultFuture<List<AdvertisementEntity>> fetchAdvertisement() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(FailureMapper.fromException(NoInternetFailure()));
      }

      final result = await remoteDataSource.getAdds();

      return Right(result);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
