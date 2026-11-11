import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/datasource/leave_application_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/accepted_fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/fallback_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_approval_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_history_request_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_blance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/search_employee_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_application_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_approvel_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/update_leave_application_request_usecase.dart';

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

const _requestFields = {
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

Map<String, dynamic> _leaveRequestJson() => {
  'LeaveTypeCode': 'ANL',
  'LeaveType': 'Annual',
  'LeaveApplicationId': 42,
  'EmployeeId': 7,
  'EmployeeName': 'Member',
  'DepartmentName': 'Operations',
  'DesignationName': 'Officer',
  'ApplicationDate': '2025-01-01',
  'RejoiningDate': '2025-01-04',
  'TotalLeaveDays': 2,
  'Remarks': 'Family event',
  'SupervisorName': 'Manager',
  'FullName': 'Member',
  'FallbackEmployeeCode': 'EMP-4',
  'FallbackPersonId': 4,
  'FallbackPersonName': 'Grace',
  'CurrentStage': 'Manager',
  'StageCode': 'MGR',
  'FromDate': '2025-01-02',
  'ToDate': '2025-01-03',
  'EmployeeCode': 'EMP-3',
};

Map<String, dynamic> _balanceJson() => {
  'LeaveTypeCode': 'ANL',
  'LeaveType': 'Annual',
  'EmployeeId': 7,
  'EmployeeCode': 'EMP-3',
  'TotalLeaveDays': 20.0,
  'Balance': 14.0,
  'TotalLeaveApplied': 6.0,
  'LastApplicationDate': '2025-01-01',
};

void main() {
  late _MockApiService apiService;
  late LeaveApplicationRemoteDataSourceImpl dataSource;
  final Map<String, dynamic> base = {
    'email': 'member@example.com',
    'userId': 7,
    'rolePermissionId': 'role-1',
    'personId': 3,
    'employeeCode': 'EMP-3',
    'mobileNumber': '01700000000',
  };
  final typeProps = LeaveTypeProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
  );
  final balanceProps = LeaveTypeBalanceProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    leaveTypeCode: 'ANL',
  );
  final searchProps = SearchEmployee(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    searchText: 'Grace',
  );
  final fallbackProps = FallbackRequestUseCaseProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
  );
  final approvalProps = LeaveApprovalProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    formDate: '2025-01-01',
    toDate: '2025-01-31',
  );
  final historyProps = LeaveHistoryRequestProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    fromDate: DateTime(2025, 1, 1),
    toDate: DateTime(2025, 1, 31),
  );
  final submitProps = SubmitLeaveApplicationProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    remarks: 'Family event',
    fallbackEmployeeCode: 'EMP-4',
    rejoiningDate: '2025-01-04',
    toDate: '2025-01-03',
    fromDate: '2025-01-02',
    leaveTypeCode: 'ANL',
    leaveStageRemarks: 'Please approve',
    formTime: '09:00',
    toTime: '17:00',
    fallbackPersonName: 'Grace',
  );
  final acceptedProps = AcceptedFallbackRequestParams(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    remarks: 'Accepted',
    leaveApplicationId: 42,
  );
  final submitApprovalProps = SubmitLeaveApprovalProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    leaveStageRemarks: 'Approved',
    leaveApplicationId: 42,
  );
  final updateProps = UpdateLeaveApplicationRequestProps(
    email: base['email']!,
    userId: base['userId']!,
    rolePermissionId: base['rolePermissionId']!,
    personId: base['personId']!,
    employeeCode: base['employeeCode']!,
    mobileNumber: base['mobileNumber']!,
    leaveApplicationId: '42',
    remarks: 'Updated',
    fallbackEmployeeCode: 'EMP-4',
    rejoiningDate: '2025-01-04',
    toDate: '2025-01-03',
    fromDate: '2025-01-02',
    leaveTypeCode: 'ANL',
    leaveStageRemarks: 'Updated',
    formTime: '09:00',
    toTime: '17:00',
  );

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    apiService = _MockApiService();
    dataSource = LeaveApplicationRemoteDataSourceImpl(apiService: apiService);
  });

  test('fetches leave types and sends the common identity fields', () async {
    when(
      () => apiService.post(ApiUrls.getLeaveType, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.getLeaveType,
        data: {
          'Data': jsonEncode([
            {'LeaveTypeCode': 'ANL', 'LeaveType': 'Annual'},
          ]),
        },
      ),
    );

    final values = await dataSource.fetchLeaveType(typeProps);

    expect(values.single.toJson(), {
      'LeaveTypeCode': 'ANL',
      'LeaveType': 'Annual',
    });
    final body =
        verify(
              () => apiService.post(
                ApiUrls.getLeaveType,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, _requestFields);
  });

  test(
    'searches employees with search text and parses employee records',
    () async {
      when(
        () => apiService.post(
          ApiUrls.getSearchEmployee,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.getSearchEmployee,
          data: {
            'Data': jsonEncode([
              {
                'FullName': 'Grace Member',
                'DateOfBirth': '1990-04-05',
                'EmployeeId': 4,
                'PersonId': 5,
                'EmployeeCode': 'EMP-4',
              },
            ]),
          },
        ),
      );

      final values = await dataSource.fetchEmployee(searchProps);

      expect(values.single.fullName, 'Grace Member');
      expect(values.single.personId, 5);
      final body =
          verify(
                () => apiService.post(
                  ApiUrls.getSearchEmployee,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body, {..._requestFields, 'SearchText': 'Grace'});
    },
  );

  test('fetches leave type balance and parses both balance objects', () async {
    when(
      () => apiService.post(ApiUrls.leaveTypeBalance, data: any(named: 'data')),
    ).thenAnswer(
      (_) async => _response(
        ApiUrls.leaveTypeBalance,
        data: {
          'Data': jsonEncode({
            'LeaveInfo': _balanceJson(),
            'LeaveSummary': [_balanceJson()],
          }),
        },
      ),
    );

    final result = await dataSource.fetchLeaveTypeBalance(balanceProps);

    expect(result.leaveInfo.balance, 14.0);
    expect(result.leaveSummary.single.leaveTypeCode, 'ANL');
    final body =
        verify(
              () => apiService.post(
                ApiUrls.leaveTypeBalance,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, {..._requestFields, 'leaveTypeCode': 'ANL'});
  });

  test(
    'fetches fallback, approval, and history applications with their filters',
    () async {
      final rows = jsonEncode([_leaveRequestJson()]);
      when(
        () => apiService.post(
          ApiUrls.getFallbackRequest,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async =>
            _response(ApiUrls.getFallbackRequest, data: {'Data': rows}),
      );
      when(
        () =>
            apiService.post(ApiUrls.getLeaveApproval, data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(ApiUrls.getLeaveApproval, data: {'Data': rows}),
      );
      when(
        () => apiService.post(
          ApiUrls.getLeaveHistoryRequest,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async =>
            _response(ApiUrls.getLeaveHistoryRequest, data: {'Data': rows}),
      );

      expect(
        (await dataSource.fetchFallbackRequest(
          fallbackProps,
        )).single.leaveApplicationId,
        42,
      );
      expect(
        (await dataSource.fetchLeaveApproval(approvalProps)).single.fromDate,
        DateTime(2025, 1, 2),
      );
      expect(
        (await dataSource.fetchLeaveHistory(historyProps)).single.employeeCode,
        'EMP-3',
      );
      final approvalBody =
          verify(
                () => apiService.post(
                  ApiUrls.getLeaveApproval,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(approvalBody, {
        ..._requestFields,
        'FromDate': '2025-01-01',
        'ToDate': '2025-01-31',
      });
      final historyBody =
          verify(
                () => apiService.post(
                  ApiUrls.getLeaveHistoryRequest,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(historyBody['FromDate'], historyProps.fromDate.toString());
      expect(historyBody['ToDate'], historyProps.toDate.toString());
    },
  );

  test(
    'submits application, fallback response, and approval payloads',
    () async {
      when(
        () => apiService.post(
          ApiUrls.submitLeaveApplication,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.submitLeaveApplication,
          data: {'Data': 'submitted'},
        ),
      );
      when(
        () =>
            apiService.post(ApiUrls.acceptedFallback, data: any(named: 'data')),
      ).thenAnswer(
        (_) async =>
            _response(ApiUrls.acceptedFallback, data: {'Data': 'accepted'}),
      );
      when(
        () => apiService.post(
          ApiUrls.submitLeaveApproval,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async =>
            _response(ApiUrls.submitLeaveApproval, data: {'Data': 'approved'}),
      );

      expect(await dataSource.submitLeaveApplication(submitProps), 'submitted');
      expect(await dataSource.acceptedFallback(acceptedProps), 'accepted');
      expect(
        await dataSource.submitLeaveApproval(submitApprovalProps),
        'approved',
      );

      final body =
          verify(
                () => apiService.post(
                  ApiUrls.submitLeaveApplication,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['LeaveTypeCode'], 'ANL');
      expect(body['FallbackEmployeeCode'], 'EMP-4');
      expect(body['FallbackPersonName'], 'Grace');
      expect(body['FromDate'], '2025-01-02');
      final acceptedBody =
          verify(
                () => apiService.post(
                  ApiUrls.acceptedFallback,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(acceptedBody['Remarks'], 'Accepted');
      expect(acceptedBody['LeaveApplicationId'], 42);
      final approvalBody =
          verify(
                () => apiService.post(
                  ApiUrls.submitLeaveApproval,
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(approvalBody['LeaveStageRemarks'], 'Approved');
      expect(approvalBody['LeaveApplicationId'], 42);
    },
  );

  test('updates an application and sends update-specific values', () async {
    when(
      () => apiService.post(
        ApiUrls.updateLeaveApplication,
        data: any(named: 'data'),
      ),
    ).thenAnswer(
      (_) async =>
          _response(ApiUrls.updateLeaveApplication, data: {'Data': 'updated'}),
    );

    expect(await dataSource.updateLeaveApplication(updateProps), 'updated');
    final body =
        verify(
              () => apiService.post(
                ApiUrls.updateLeaveApplication,
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body['LeaveApplicationId'], '42');
    expect(body['LeaveTypeCode'], 'ANL');
    expect(body['Remarks'], 'Updated');
  });

  test(
    'returns empty employee results and rejects empty leave-type data',
    () async {
      when(
        () => apiService.post(ApiUrls.getLeaveType, data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(ApiUrls.getLeaveType, data: {'Data': ''}),
      );
      when(
        () => apiService.post(
          ApiUrls.getSearchEmployee,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.getSearchEmployee,
          data: {'Data': jsonEncode([])},
        ),
      );

      expect(await dataSource.fetchEmployee(searchProps), isEmpty);
      await expectLater(
        dataSource.fetchLeaveType(typeProps),
        throwsA(isA<ServerException>()),
      );
    },
  );

  test(
    'throws server and format errors for unsuccessful datasource responses',
    () async {
      when(
        () => apiService.post(ApiUrls.getLeaveType, data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.getLeaveType,
          statusCode: HttpStatus.internalServerError,
        ),
      );
      expect(
        dataSource.fetchLeaveType(typeProps),
        throwsA(isA<ServerException>()),
      );

      when(
        () => apiService.post(
          ApiUrls.submitLeaveApplication,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _response(
          ApiUrls.submitLeaveApplication,
          data: {'Data': '', 'Status': 'failed', 'Message': 'Not allowed'},
        ),
      );
      await expectLater(
        dataSource.submitLeaveApplication(submitProps),
        throwsA(isA<ServerException>()),
      );

      when(
        () =>
            apiService.post(ApiUrls.leaveTypeBalance, data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(ApiUrls.leaveTypeBalance, data: {'Data': null}),
      );
      await expectLater(
        dataSource.fetchLeaveTypeBalance(balanceProps),
        throwsA(isA<Exception>()),
      );

      when(
        () => apiService.post(
          ApiUrls.getFallbackRequest,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async =>
            _response(ApiUrls.getFallbackRequest, data: {'Data': null}),
      );
      await expectLater(
        dataSource.fetchFallbackRequest(fallbackProps),
        throwsA(isA<Exception>()),
      );
    },
  );
}
