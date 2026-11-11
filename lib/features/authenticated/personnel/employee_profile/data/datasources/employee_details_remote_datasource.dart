import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/models/employee_details_model.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';

abstract class EmployeeDetailsRemoteDataSource {
  Future<EmployeeDetailsModel> fetchEmployeeDetailsDataSource(
    EmployeeDetailsProps props,
  );
}

class EmployeeDetailsRemoteDataSourceImpl
    implements EmployeeDetailsRemoteDataSource {
  final ApiService apiService;

  EmployeeDetailsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<EmployeeDetailsModel> fetchEmployeeDetailsDataSource(
    EmployeeDetailsProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.getEmployeeDetails,
        data: {
          "UserName": props.email,
          "MobileNo": props.mobileNumber,
          "MobileNumber": props.mobileNumber,
          "RolePermissionId": props.rolePermissionId,
          "ByUserId": props.userId,
          "UID": props.userId,
          "EmployeeCode": props.employeeCode,
          "PersonId": props.personId,
          "RequestFrom": "MobileApp",
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        final errorMessage = response.data?['Message'];
        final statusMessage = response.data?['Status'];
        if (statusMessage == "failed") {
          throw ServerException(message: errorMessage ?? "Server Error");
        }
        if (dataString is! String || dataString.isEmpty) {
          throw ServerException(message: "Server Error");
        }

        final jsonResponse = JsonUtil.decodeModelList(dataString);
        if (jsonResponse.isEmpty) {
          throw ServerException(message: "Server Error");
        }
        return EmployeeDetailsModel.fromJson(jsonResponse.first);
      } else {
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      rethrow;
    }
  }
}
