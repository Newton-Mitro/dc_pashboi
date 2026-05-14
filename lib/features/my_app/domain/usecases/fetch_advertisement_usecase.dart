import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/my_app/domain/entities/advertisement_entity.dart';
import 'package:pashboi/features/my_app/domain/repositories/app_status_repository.dart';

class FetchAdvertisementUseCase
    implements UseCase<List<AdvertisementEntity>, NoParams> {
  final AppStatusRepository repository;

  FetchAdvertisementUseCase(this.repository);

  @override
  ResultFuture<List<AdvertisementEntity>> call(NoParams params) async {
    return await repository.fetchAdvertisement();
  }
}
