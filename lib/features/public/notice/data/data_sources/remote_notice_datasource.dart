import 'dart:io';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/product_api_service.dart';
import 'package:pashboi/features/public/notice/data/models/notice_model.dart';

abstract class NoticeRemoteDataSource {
  Future<List<NoticeModel>> findNotice();
}

class NoticeRemoteDataSourceImpl implements NoticeRemoteDataSource {
  final ProductApiService productApiService;

  NoticeRemoteDataSourceImpl({required this.productApiService});

  @override
  Future<List<NoticeModel>> findNotice() async {
    try {
      final response = await productApiService.get(ApiUrls.getNotices);

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data?['pages']; // already a List<dynamic>

        if (data == null || data is! List) {
          throw Exception('Invalid response format: expected a list');
        }

        final List<NoticeModel> depositPolicies =
            data.map((json) => NoticeModel.fromJson(json)).toList();

        return depositPolicies;
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
