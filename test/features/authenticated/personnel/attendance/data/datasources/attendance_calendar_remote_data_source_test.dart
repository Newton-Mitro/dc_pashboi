import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

Response<dynamic> _response({
  int statusCode = HttpStatus.ok,
  dynamic data,
  Map<String, List<String>> headers = const {},
}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ApiUrls.fetchAttendance),
    statusCode: statusCode,
    data: data,
    headers: Headers.fromMap(headers),
  );
}

void main() {
  late _MockApiService apiService;
  late AttendanceRemoteDataSourceImpl dataSource;
  const props = AttendanceProps(
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

  test('sends the employee/date request and maps attendance rows', () async {
    when(
      () => apiService.post(ApiUrls.fetchAttendance, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        data: {
          'Data': jsonEncode([
            {
              'Id': 'attendance-1',
              'AttendanceDate': '2025-06-18',
              'Status': 'Present',
              'PunchIn': '09:00',
              'PunchOut': '17:00',
              'EmployeeCode': 'EMP-3',
            },
          ]),
        },
        headers: {
          'token': ['response-token'],
        },
      ),
    );

    final result = await dataSource.fetchAttendance(props);

    expect(result.single.id, 'attendance-1');
    expect(result.single.attendanceDate, '2025-06-18');
    expect(result.single.punchIn, '09:00');
    expect(result.single.punchOut, '17:00');
    final body =
        verify(
              () => apiService.post(
                ApiUrls.fetchAttendance,
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
      'FromDate': '2025-06-01',
      'ToDate': '2025-06-30',
    });
  });

  test('returns an empty attendance list when the API data is empty', () async {
    when(
      () => apiService.post(ApiUrls.fetchAttendance, data: any(named: 'data')),
    ).thenAnswer((_) async => _response(data: {'Data': jsonEncode([])}));

    expect(await dataSource.fetchAttendance(props), isEmpty);
  });

  test('rejects a response without attendance data', () async {
    when(
      () => apiService.post(ApiUrls.fetchAttendance, data: any(named: 'data')),
    ).thenAnswer((_) async => _response(data: {'Data': null}));

    expect(dataSource.fetchAttendance(props), throwsA(isA<Exception>()));
  });

  test('rejects unsuccessful HTTP responses', () async {
    when(
      () => apiService.post(ApiUrls.fetchAttendance, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(statusCode: HttpStatus.internalServerError),
    );

    expect(dataSource.fetchAttendance(props), throwsA(isA<Exception>()));
  });
}
