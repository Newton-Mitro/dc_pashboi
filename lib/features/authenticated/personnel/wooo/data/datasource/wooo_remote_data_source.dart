import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_data_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';

abstract class WoooRemoteDataSource {
  Future<List<WoooTypeModel>> fetchWoooTypes(WooTypeUseCaseProps props);
  Future<String> submitWoooApplication(SubmitWoooApplicationPropsProps props);
  Future<List<WoooDataModel>> getWoooData(GetWoooProps props);
  Future<String> updateWoooData(UpdateWoooProps props);
  Future<List<WoooDataModel>> fetchWoooApprovalData(GetWoooApprovalProps props);

  Future<String> submitWoooApprovalData(WoooApprovalSubmitUseCaseProps props);
}

class WoooRemoteDataSourceImpl implements WoooRemoteDataSource {
  final ApiService apiService;
  WoooRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<WoooTypeModel>> fetchWoooTypes(WooTypeUseCaseProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getWoooLeaveType,
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

            final searchEmployee =
                jsonResponse
                    .map<WoooTypeModel>((json) => WoooTypeModel.fromJson(json))
                    .toList();
            return searchEmployee;
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

  @override
  Future<String> submitWoooApplication(
    SubmitWoooApplicationPropsProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.addEmployeeWorkingOutofOffice,
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
          "FromDate": props.fromDate,
          "ToDate": props.toDate,
          "RejoiningDate": props.rejoiningDate,
          "Reason": props.reason,
          "WoooTypeCode": props.woooTypeCode,
          "isHourly": props.isHourly,
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
            return dataString;
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

  @override
  Future<List<WoooDataModel>> getWoooData(GetWoooProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getWoooData,
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
          "ToDate": props.toDate.toIso8601String(),
          "FromDate": props.fromDate.toIso8601String(),
          "EmployeeWoooId": -1,
          "IsSupervisorTreeWise": false,
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

            final woooData =
                jsonResponse
                    .map<WoooDataModel>((json) => WoooDataModel.fromJson(json))
                    .toList();
            return woooData;
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

  @override
  Future<String> updateWoooData(UpdateWoooProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.updateEmployeeWorkingOutofOffice,
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
          "FromDate": props.fromDate,
          "ToDate": props.toDate,
          "RejoiningDate": props.rejoiningDate,
          "Reason": props.reason,
          "WoooTypeCode": props.woooTypeCode,
          "isHourly": props.isHourly,
          "LeaveApplicationId": props.leaveApplicationId,
          "EmployeeWoooId": props.leaveApplicationId,
          "IsSupervisorTreeWise": false,
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
            return dataString;
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

  @override
  Future<List<WoooDataModel>> fetchWoooApprovalData(
    GetWoooApprovalProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.getSupervisorApprovalRequestListForWOOO,
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
          "ToDate": props.toDate.toIso8601String(),
          "FromDate": props.fromDate.toIso8601String(),
          "EmployeeWoooId": -1,
          "IsSupervisorTreeWise": false,
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

            final woooData =
                jsonResponse
                    .map<WoooDataModel>((json) => WoooDataModel.fromJson(json))
                    .toList();
            return woooData;
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

  @override
  Future<String> submitWoooApprovalData(
    WoooApprovalSubmitUseCaseProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.updateSupervisorApprovalRequestForWOOO,
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
          "Status": props.status,
          "EmployeeWoooId": props.employeeWoooId,
          "IsSupervisorTreeWise": false,
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
            return dataString;
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
