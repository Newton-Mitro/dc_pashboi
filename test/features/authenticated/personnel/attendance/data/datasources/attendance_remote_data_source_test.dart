import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

Response<dynamic> _response(
  String endpoint, {
  int statusCode = 200,
  dynamic data,
}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: endpoint),
    statusCode: statusCode,
    data: data,
  );
}

void main() {
  late _MockApiService apiService;
  late AttendanceRemoteDataSourceImpl dataSource;
  const props = TodayPunchProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-01',
    toDate: '2025-06-30',
  );

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    apiService = _MockApiService();
    dataSource = AttendanceRemoteDataSourceImpl(apiService: apiService);
  });

  test(
    'fetchPaunch sends employee and date filters and parses results',
    () async {
      when(
        () => apiService.post(ApiUrls.fetchPunch, data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.fetchPunch,
          data: {
            'Data': jsonEncode([
              {
                'Id': 5,
                'EmployeeName': 'Member',
                'CheckInTime': '09:00',
                'EmployeeCode': 'EMP-3',
              },
            ]),
          },
        ),
      );

      final result = await dataSource.fetchPaunch(props);

      expect(result.single.id, 5);
      expect(result.single.employeeName, 'Member');
      final body =
          verify(
                () => apiService.post(
                  ApiUrls.fetchPunch,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body, {
        'UserName': 'member@example.com',
        'MobileNo': '01700000000',
        'MobileNumber': '01700000000',
        'RolePermissionId': 'role-1',
        'ByUserId': 7,
        'UID': 7,
        'EmployeeCode': 'EMP-3',
        'PersonId': 3,
        'RequestFrom': 'MobileApp',
        'ToDate': '2025-06-30',
        'fromDate': '2025-06-01',
      });
    },
  );

  test('fetchPaunch returns an empty list for an empty response', () async {
    when(
      () => apiService.post(ApiUrls.fetchPunch, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(ApiUrls.fetchPunch, data: {'Data': ''}),
    );

    expect(await dataSource.fetchPaunch(props), isEmpty);
  });

  test('fetchPaunch rejects unsuccessful HTTP responses', () async {
    when(
      () => apiService.post(ApiUrls.fetchPunch, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.fetchPunch,
        statusCode: HttpStatus.internalServerError,
      ),
    );

    expect(dataSource.fetchPaunch(props), throwsA(isA<Exception>()));
  });
}
