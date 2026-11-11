import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/datasource/wooo_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

Response<dynamic> _response(
  String endpoint, {
  int statusCode = HttpStatus.ok,
  dynamic data,
}) => Response<dynamic>(
  requestOptions: RequestOptions(path: endpoint),
  statusCode: statusCode,
  data: data,
);

void main() {
  late _MockApiService apiService;
  late WoooRemoteDataSourceImpl dataSource;
  final fromDate = DateTime.utc(2025, 6, 1);
  final toDate = DateTime.utc(2025, 6, 30);

  const identity = {
    'UserName': 'member@example.com',
    'MobileNo': '01700000000',
    'MobileNumber': '01700000000',
    'RolePermissionId': 'role-1',
    'ByUserId': 7,
    'UID': 7,
    'EmployeeCode': 'EMP-3',
    'PersonId': 3,
    'RequestFrom': 'MobileApp',
  };
  final typeProps = WooTypeUseCaseProps(
    email: identity['UserName']! as String,
    userId: identity['ByUserId']! as int,
    rolePermissionId: identity['RolePermissionId']! as String,
    personId: identity['PersonId']! as int,
    employeeCode: identity['EmployeeCode']! as String,
    mobileNumber: identity['MobileNo']! as String,
  );
  final submitProps = SubmitWoooApplicationPropsProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-02',
    toDate: '2025-06-03',
    rejoiningDate: '2025-06-04',
    reason: 'Working remotely',
    woooTypeCode: 'REMOTE',
    isHourly: false,
  );
  final getProps = GetWoooProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: fromDate,
    toDate: toDate,
  );
  final updateProps = UpdateWoooProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-02',
    toDate: '2025-06-03',
    rejoiningDate: '2025-06-04',
    reason: 'Updated remote work',
    woooTypeCode: 'REMOTE',
    isHourly: true,
    leaveApplicationId: 5,
  );
  final approvalProps = GetWoooApprovalProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: fromDate,
    toDate: toDate,
  );
  const approvalSubmitProps = WoooApprovalSubmitUseCaseProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    employeeWoooId: '5',
    status: 'Approved',
  );

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    apiService = _MockApiService();
    dataSource = WoooRemoteDataSourceImpl(apiService: apiService);
  });

  test('fetchWoooTypes sends identity and parses type data', () async {
    when(
      () => apiService.post(ApiUrls.getWoooLeaveType, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.getWoooLeaveType,
        data: {
          'Data': jsonEncode([
            {
              'WoooTypeId': 2,
              'WoooTypeName': 'Remote work',
              'WoooTypeCode': 'REMOTE',
              'BackDateDays': 3,
              'FromDate': '2025-06-01',
              'ToDate': '2025-06-30',
            },
          ]),
        },
      ),
    );

    final result = await dataSource.fetchWoooTypes(typeProps);

    expect(result.single.woooTypeName, 'Remote work');
    final body =
        verify(
              () => apiService.post(
                ApiUrls.getWoooLeaveType,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, identity);
  });

  test('submitWoooApplication sends all application fields', () async {
    when(
      () => apiService.post(
        ApiUrls.addEmployeeWorkingOutofOffice,
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.addEmployeeWorkingOutofOffice,
        data: {'Data': 'Application submitted'},
      ),
    );

    expect(
      await dataSource.submitWoooApplication(submitProps),
      'Application submitted',
    );
    final body =
        verify(
              () => apiService.post(
                ApiUrls.addEmployeeWorkingOutofOffice,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, {
      ...identity,
      'FromDate': '2025-06-02',
      'ToDate': '2025-06-03',
      'RejoiningDate': '2025-06-04',
      'Reason': 'Working remotely',
      'WoooTypeCode': 'REMOTE',
      'isHourly': false,
    });
  });

  test('getWoooData sends date filters and parses history records', () async {
    when(
      () => apiService.post(ApiUrls.getWoooData, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.getWoooData,
        data: {
          'Data': jsonEncode([
            {
              'EmployeeWoooId': 5,
              'totalRecords': 1,
              'WoooTypeCode': 'REMOTE',
              'RejoiningDate': '2025-06-04',
              'Reason': 'Working remotely',
              'isHourly': false,
              'ByMMS': false,
              'AppliedBy': 7,
              'RejectedBy': 0,
              'TotalDays': 2,
              'TotalHour': '0',
              'ApplicationDate': '2025-06-01',
              'WoooTypeId': 2,
              'WoooType': 'Remote work',
              'IsEditable': true,
              'IsSupervisorTreeWise': false,
              'RegisteredStatus': true,
              'EmployeeId': 7,
              'EmployeeName': 'Member',
              'Status': 'Pending',
              'FromDate': '2025-06-02',
              'ToDate': '2025-06-03',
            },
          ]),
        },
      ),
    );

    final result = await dataSource.getWoooData(getProps);

    expect(result.single.employeeWoooId, 5);
    expect(result.single.status, 'Pending');
    final body =
        verify(
              () => apiService.post(
                ApiUrls.getWoooData,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, {
      ...identity,
      'FromDate': fromDate.toIso8601String(),
      'ToDate': toDate.toIso8601String(),
      'EmployeeWoooId': -1,
      'IsSupervisorTreeWise': false,
    });
  });

  test(
    'updateWoooData sends request fields and application identifiers',
    () async {
      when(
        () => apiService.post(
          ApiUrls.updateEmployeeWorkingOutofOffice,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.updateEmployeeWorkingOutofOffice,
          data: {'Data': 'Application updated'},
        ),
      );

      expect(
        await dataSource.updateWoooData(updateProps),
        'Application updated',
      );
      final body =
          verify(
                () => apiService.post(
                  ApiUrls.updateEmployeeWorkingOutofOffice,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body, {
        ...identity,
        'FromDate': '2025-06-02',
        'ToDate': '2025-06-03',
        'RejoiningDate': '2025-06-04',
        'Reason': 'Updated remote work',
        'WoooTypeCode': 'REMOTE',
        'isHourly': true,
        'LeaveApplicationId': 5,
        'EmployeeWoooId': 5,
        'IsSupervisorTreeWise': false,
      });
    },
  );

  test(
    'fetchWoooApprovalData sends date filters and parses approval data',
    () async {
      when(
        () => apiService.post(
          ApiUrls.getSupervisorApprovalRequestListForWOOO,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.getSupervisorApprovalRequestListForWOOO,
          data: {
            'Data': jsonEncode([
              {
                'EmployeeWoooId': 9,
                'totalRecords': 1,
                'WoooTypeCode': 'REMOTE',
                'RejoiningDate': '2025-06-04',
                'Reason': 'Working remotely',
                'AppliedBy': 7,
                'RejectedBy': 0,
                'TotalDays': 2,
                'TotalHour': '0',
                'ApplicationDate': '2025-06-01',
                'WoooTypeId': 2,
                'WoooType': 'Remote work',
                'IsEditable': false,
                'IsSupervisorTreeWise': false,
                'RegisteredStatus': true,
                'EmployeeId': 7,
                'EmployeeName': 'Member',
                'Status': 'Pending',
                'FromDate': '2025-06-02',
                'ToDate': '2025-06-03',
              },
            ]),
          },
        ),
      );

      final result = await dataSource.fetchWoooApprovalData(approvalProps);

      expect(result.single.employeeWoooId, 9);
      final body =
          verify(
                () => apiService.post(
                  ApiUrls.getSupervisorApprovalRequestListForWOOO,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body, {
        ...identity,
        'FromDate': fromDate.toIso8601String(),
        'ToDate': toDate.toIso8601String(),
        'EmployeeWoooId': -1,
        'IsSupervisorTreeWise': false,
      });
    },
  );

  test('submitWoooApprovalData sends approval status and request ID', () async {
    when(
      () => apiService.post(
        ApiUrls.updateSupervisorApprovalRequestForWOOO,
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.updateSupervisorApprovalRequestForWOOO,
        data: {'Data': 'Approval saved'},
      ),
    );

    expect(
      await dataSource.submitWoooApprovalData(approvalSubmitProps),
      'Approval saved',
    );
    final body =
        verify(
              () => apiService.post(
                ApiUrls.updateSupervisorApprovalRequestForWOOO,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, {
      ...identity,
      'Status': 'Approved',
      'EmployeeWoooId': '5',
      'IsSupervisorTreeWise': false,
    });
  });

  test(
    'all endpoints reject failed API responses and non-200 statuses',
    () async {
      final requests = <({String endpoint, Future<Object?> Function() call})>[
        (
          endpoint: ApiUrls.getWoooLeaveType,
          call: () async => dataSource.fetchWoooTypes(typeProps),
        ),
        (
          endpoint: ApiUrls.addEmployeeWorkingOutofOffice,
          call: () async => dataSource.submitWoooApplication(submitProps),
        ),
        (
          endpoint: ApiUrls.getWoooData,
          call: () async => dataSource.getWoooData(getProps),
        ),
        (
          endpoint: ApiUrls.updateEmployeeWorkingOutofOffice,
          call: () async => dataSource.updateWoooData(updateProps),
        ),
        (
          endpoint: ApiUrls.getSupervisorApprovalRequestListForWOOO,
          call: () async => dataSource.fetchWoooApprovalData(approvalProps),
        ),
        (
          endpoint: ApiUrls.updateSupervisorApprovalRequestForWOOO,
          call:
              () async =>
                  dataSource.submitWoooApprovalData(approvalSubmitProps),
        ),
      ];

      for (final request in requests) {
        when(
          () => apiService.post(request.endpoint, data: any(named: 'data')),
        ).thenAnswer(
          (_) async => _response(
            request.endpoint,
            data: {'Status': 'failed', 'Message': 'WOOO request rejected'},
          ),
        );
        await expectLater(
          request.call(),
          throwsA(
            isA<ServerException>().having(
              (error) => error.message,
              'message',
              'WOOO request rejected',
            ),
          ),
        );

        when(
          () => apiService.post(request.endpoint, data: any(named: 'data')),
        ).thenAnswer(
          (_) async => _response(
            request.endpoint,
            statusCode: HttpStatus.internalServerError,
          ),
        );
        await expectLater(request.call(), throwsA(isA<ServerException>()));

        when(
          () => apiService.post(request.endpoint, data: any(named: 'data')),
        ).thenAnswer(
          (_) async => _response(request.endpoint, data: {'Data': ''}),
        );
        await expectLater(request.call(), throwsA(isA<ServerException>()));
      }
    },
  );
}
