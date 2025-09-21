import 'dart:io';

import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/core/utils/json_util.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/model/attendance_model.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/model/today_punch_model.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<AttendanceModel>> fetchAttendance(AttendanceProps params);

  Future<List<TodayPunchModel>> fetchPaunch(TodayPunchProps params);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final ApiService apiService;

  AttendanceRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<AttendanceModel>> fetchAttendance(props) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchAttendance,
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
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        if (dataString == null) throw Exception('Invalid response format');

        final token = response.headers['token']?.first;
        final jsonResponse = JsonUtil.decodeModelList(dataString);

        final attendanceList =
            jsonResponse.map<AttendanceModel>((item) {
              return AttendanceModel.fromJson({
                ...item,
                "access_token": token,
                "refresh_token": token,
              });
            }).toList();

        return attendanceList;
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // fetchPaunch
  @override
  Future<List<TodayPunchModel>> fetchPaunch(TodayPunchProps props) async {
    try {
      final response = await apiService.post(
        ApiUrls.fetchPunch,
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
          "ToDate": props.toDate,
          "fromDate": props.fromDate,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final dataString = response.data?['Data'];
        if (dataString == null) throw Exception('Invalid response format');
        if (dataString == "") return [];

        final token = response.headers['token']?.first;
        final jsonResponse = JsonUtil.decodeModelList(dataString);

        final attendanceList =
            jsonResponse.map<TodayPunchModel>((item) {
              return TodayPunchModel.fromJson({
                ...item,
                "access_token": token,
                "refresh_token": token,
              });
            }).toList();

        return attendanceList;
      } else {
        throw Exception('Login failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
