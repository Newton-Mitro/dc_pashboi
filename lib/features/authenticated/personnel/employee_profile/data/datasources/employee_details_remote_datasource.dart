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
        if (dataString == null || dataString.isNotEmpty) {
          if (statusMessage != null && statusMessage == "failed") {
            throw ServerException(message: errorMessage);
          } else {
            final jsonResponse = JsonUtil.decodeModelList(dataString);

            final personModel = EmployeeDetailsModel.fromJson(
              jsonResponse.first,
            );

            return personModel;
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
