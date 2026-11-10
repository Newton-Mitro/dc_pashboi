import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/utils/fetch_remote_result.dart';
import 'package:pashboi/features/public/project/data/models/project_model.dart';
import 'package:pashboi/features/public/project/data/data_source/project_remote_data_source.dart';
import 'package:pashboi/features/public/project/domain/entites/project_entity.dart';
import 'package:pashboi/features/public/project/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<ProjectEntity>> findProject() async {
    return fetchRemoteResult<List<ProjectModel>, List<ProjectEntity>>(
      remoteDataSource.findProject,
    );
  }
}
