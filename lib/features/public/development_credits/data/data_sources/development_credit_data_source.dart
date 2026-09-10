import 'dart:io';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/development_credits/data/models/development_credits_models.dart';

abstract class DevelopmentCreditRemoteDataSource {
  Future<List<DevelopmentCreditsModel>> fetchDevelopmentData();
}

class DevelopmentCreditRemoteDataSourceImpl
    implements DevelopmentCreditRemoteDataSource {
  final ProductApiService productApiService;

  DevelopmentCreditRemoteDataSourceImpl({required this.productApiService});

  @override
  Future<List<DevelopmentCreditsModel>> fetchDevelopmentData() async {
    try {
      final response = await productApiService.get(ApiUrls.getDevTeams);

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data?['data'];

        if (data == null || data is! List) {
          throw Exception('Invalid response format: expected a list');
        }

        final List<DevelopmentCreditsModel> developmentCredit =
            data.map((json) => DevelopmentCreditsModel.fromJson(json)).toList();

        return developmentCredit;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
