import 'dart:io';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/service_centers/data/models/service_center_model.dart';

abstract class ServiceCenterRemoteDataSource {
  Future<List<ServiceCenterModel>> findAllServiceCenters();
}

class ServiceCenterRemoteDataSourceImpl
    implements ServiceCenterRemoteDataSource {
  final ProductApiService productApiService;

  ServiceCenterRemoteDataSourceImpl({required this.productApiService});

  @override
  Future<List<ServiceCenterModel>> findAllServiceCenters() async {
    try {
      final response = await productApiService.get(ApiUrls.getAllBranch);

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data; // already a List<dynamic>

        if (data == null || data is! List) {
          throw Exception('Invalid response format: expected a list');
        }

        final List<ServiceCenterModel> depositPolicies =
            data.map((json) => ServiceCenterModel.fromJson(json)).toList();

        return depositPolicies;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
