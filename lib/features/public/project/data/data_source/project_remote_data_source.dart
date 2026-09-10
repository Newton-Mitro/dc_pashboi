import 'dart:io';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/project/data/models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> findProject();
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ProductApiService productApiService;

  ProjectRemoteDataSourceImpl({required this.productApiService});

  @override
  Future<List<ProjectModel>> findProject() async {
    try {
      final response = await productApiService.get(ApiUrls.getProject);

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data?['Project'];

        if (data == null || data is! List) {
          throw Exception('Invalid response format: expected a list');
        }

        final List<ProjectModel> depositPolicies =
            data.map((json) => ProjectModel.fromJson(json)).toList();

        return depositPolicies;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
