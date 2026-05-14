import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/features/my_app/domain/entities/advertisement_entity.dart';
import 'package:pashboi/features/my_app/domain/entities/app_status_entity.dart';

abstract class AppStatusRepository {
  ResultFuture<AppStatusEntity> fetchAppStatus(int varsion);
  ResultFuture<List<AdvertisementEntity>> fetchAdvertisement();
}
