import 'dart:convert';
import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/terms_and_condition/domain/usecases/fetch_term_and_condition_usecase.dart';

abstract class TermAndConditionRemoteDataSource {
  Future<String> fetchTermAndCondition(FetchTermAndConditionProps props);
}

class TermAndConditionRemoteDataSourceImpl
    implements TermAndConditionRemoteDataSource {
  final ApiService apiService;

  TermAndConditionRemoteDataSourceImpl({required this.apiService});

  @override
  Future<String> fetchTermAndCondition(FetchTermAndConditionProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchTermAndCondition,
        data: {
          "ApplicationName": "MFS",
          "ContentName": props.contentName,
          "Application": "PassBook",
          "UserName": props.email,
          "UID": props.userId,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "RolePermissionId": props.rolePermissionId,
          "ByUserId": props.userId,
          "EmployeeCode": props.employeeCode,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (dataString == null || dataString.isNotEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage);
          } else {
            final Map<String, dynamic> data = jsonDecode(dataString);
            final String content = data['BanglaContent'] ?? '';

            return content;
          }
        }
        throw ServerException(message: "Server Error");
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }
}
