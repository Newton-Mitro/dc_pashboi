import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/datasources/employee_details_remote_datasource.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';

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
  late EmployeeDetailsRemoteDataSourceImpl dataSource;
  const props = EmployeeDetailsProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    apiService = _MockApiService();
    dataSource = EmployeeDetailsRemoteDataSourceImpl(apiService: apiService);
  });

  test(
    'fetches and parses employee details using the authenticated context',
    () async {
      when(
        () => apiService.post(
          ApiUrls.getEmployeeDetails,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.getEmployeeDetails,
          data: {
            'Data': jsonEncode([
              {'EmployeeId': 7, 'FullName': 'Member', 'EmployeeCode': 'EMP-3'},
            ]),
          },
        ),
      );

      final employee = await dataSource.fetchEmployeeDetailsDataSource(props);

      expect(employee.id, 7);
      expect(employee.fullName, 'Member');
      final body =
          verify(
                () => apiService.post(
                  ApiUrls.getEmployeeDetails,
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
      });
    },
  );

  test('throws the server message when the response reports failure', () {
    when(
      () =>
          apiService.post(ApiUrls.getEmployeeDetails, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.getEmployeeDetails,
        data: {
          'Data': '',
          'Status': 'failed',
          'Message': 'Profile unavailable',
        },
      ),
    );

    expect(
      dataSource.fetchEmployeeDetailsDataSource(props),
      throwsA(
        isA<ServerException>().having(
          (exception) => exception.message,
          'message',
          'Profile unavailable',
        ),
      ),
    );
  });

  test('rejects empty profile responses', () {
    when(
      () =>
          apiService.post(ApiUrls.getEmployeeDetails, data: any(named: 'data')),
    ).thenAnswer(
      (_) async =>
          _response(ApiUrls.getEmployeeDetails, data: {'Data': jsonEncode([])}),
    );

    expect(
      dataSource.fetchEmployeeDetailsDataSource(props),
      throwsA(isA<ServerException>()),
    );
  });

  test('rejects unsuccessful HTTP responses', () {
    when(
      () =>
          apiService.post(ApiUrls.getEmployeeDetails, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.getEmployeeDetails,
        statusCode: HttpStatus.internalServerError,
      ),
    );

    expect(
      dataSource.fetchEmployeeDetailsDataSource(props),
      throwsA(isA<ServerException>()),
    );
  });
}
