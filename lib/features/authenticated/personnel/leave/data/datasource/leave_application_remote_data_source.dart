import 'dart:convert';
import 'dart:io';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/fallback_request_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_info_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_summery_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/search_employee_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_history_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_blance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_application_usecase.dart';

abstract class LeaveApplicationRemoteDataSource {
  Future<String> submitLeaveApplication(SubmitLeaveApplicationProps props);
  Future<List<LeaveTypeModel>> fetchLeaveType(LeaveTypeProps props);
  Future<LeaveTypeBalanceDto> fetchLeaveTypeBalance(
    LeaveTypeBalanceProps props,
  );
  Future<List<SearchEmployeeModel>> fetchEmployee(props);
  Future<String> acceptedFallback(props);
  Future<List<LeaveApplicationRequestModel>> fetchFallbackRequest(props);
  Future<List<LeaveApplicationRequestModel>> fetchLeaveApproval(
    LeaveApprovalProps props,
  );
  Future<String> submitLeaveApproval(props);

  Future<List<LeaveApplicationRequestModel>> fetchLeaveHistory(
    LeaveHistoryRequestProps props,
  );

  Future<String> updateLeaveApplication(props);
}

class LeaveApplicationRemoteDataSourceImpl
    implements LeaveApplicationRemoteDataSource {
  final ApiService apiService;
  LeaveApplicationRemoteDataSourceImpl({required this.apiService});
  @override
  Future<List<SearchEmployeeModel>> fetchEmployee(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getSearchEmployee,
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
          "SearchText": props.searchText,
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
                    .map<SearchEmployeeModel>(
                      (json) => SearchEmployeeModel.fromJson(json),
                    )
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
  Future<List<LeaveTypeModel>> fetchLeaveType(LeaveTypeProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getLeaveType,
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

            final leaveTypes =
                jsonResponse
                    .map<LeaveTypeModel>(
                      (json) => LeaveTypeModel.fromJson(json),
                    )
                    .toList();
            return leaveTypes;
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
  Future<LeaveTypeBalanceDto> fetchLeaveTypeBalance(
    LeaveTypeBalanceProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.leaveTypeBalance,
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
          "leaveTypeCode": props.leaveTypeCode,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data?['Data'];

        if (data == null) throw Exception('Invalid response format');

        final newData = jsonDecode(data);

        final leaveInfo = LeaveInfoModel.fromJson(newData['LeaveInfo']);
        final leaveSummaryList =
            (newData['LeaveSummary'] as List)
                .map((e) => LeaveSummeryModel.fromJson(e))
                .toList();

        return LeaveTypeBalanceDto(
          leaveInfo: leaveInfo,
          leaveSummary: leaveSummaryList,
        );
      } else {
        throw Exception('Request failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> submitLeaveApplication(
    SubmitLeaveApplicationProps props,
  ) async {
    try {
      final response = await apiService.post(
        ApiUrls.submitLeaveApplication,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "RequestFrom": "MobileApp",
          "LeaveTypeCode": props.leaveTypeCode,
          "FromDate": props.fromDate,
          "ToDate": props.toDate,
          "FormTime": props.formTime,
          "ToTime": props.toTime,
          "RejoiningDate": props.rejoiningDate,
          "FallbackEmployeeCode": props.fallbackEmployeeCode,
          "Remarks": props.remarks,
          "LeaveStageRemarks": props.leaveStageRemarks,
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
  Future<String> acceptedFallback(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.acceptedFallback,
        data: {
          "Remarks": props.remarks,
          "LeaveApplicationId": props.leaveApplicationId,
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
  Future<List<LeaveApplicationRequestModel>> fetchFallbackRequest(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getFallbackRequest,
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
        if (dataString == null) throw Exception('Invalid response format');
        final jsonResponse = JsonUtil.decodeModelList(dataString);

        final fallbackRequest =
            jsonResponse
                .map<LeaveApplicationRequestModel>(
                  (json) => LeaveApplicationRequestModel.fromJson(json),
                )
                .toList();
        return fallbackRequest;
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LeaveApplicationRequestModel>> fetchLeaveApproval(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getLeaveApproval,
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
          "FromDate": props.formDate,
          "ToDate": props.toDate,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        if (dataString == null) throw Exception('Invalid response format');
        final jsonResponse = JsonUtil.decodeModelList(dataString);

        final fallbackRequest =
            jsonResponse
                .map<LeaveApplicationRequestModel>(
                  (json) => LeaveApplicationRequestModel.fromJson(json),
                )
                .toList();
        return fallbackRequest;
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> submitLeaveApproval(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.submitLeaveApproval,
        data: {
          "LeaveApplicationId": props.leaveApplicationId,
          "LeaveStageRemarks": props.leaveStageRemarks,
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
  Future<List<LeaveApplicationRequestModel>> fetchLeaveHistory(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.getLeaveHistoryRequest,
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
          "ToDate": props.toDate.toString(),
          "FromDate": props.fromDate.toString(),
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        if (dataString == null) throw Exception('Invalid response format');
        final jsonResponse = JsonUtil.decodeModelList(dataString);

        final fallbackRequest =
            jsonResponse
                .map<LeaveApplicationRequestModel>(
                  (json) => LeaveApplicationRequestModel.fromJson(json),
                )
                .toList();
        return fallbackRequest;
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateLeaveApplication(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.updateLeaveApplication,
        data: {
          "UserName": props.email,
          "UID": props.userId,
          "ByUserId": props.userId,
          "RolePermissionId": props.rolePermissionId,
          "PersonId": props.personId,
          "EmployeeCode": props.employeeCode,
          "MobileNumber": props.mobileNumber,
          "MobileNo": props.mobileNumber,
          "RequestFrom": "MobileApp",
          "LeaveTypeCode": props.leaveTypeCode,
          "FromDate": props.fromDate,
          "ToDate": props.toDate,
          "FormTime": props.formTime,
          "ToTime": props.toTime,
          "RejoiningDate": props.rejoiningDate,
          "FallbackEmployeeCode": props.fallbackEmployeeCode,
          "Remarks": props.remarks,
          "LeaveStageRemarks": props.leaveStageRemarks,
          "LeaveApplicationId": props.leaveApplicationId,
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
