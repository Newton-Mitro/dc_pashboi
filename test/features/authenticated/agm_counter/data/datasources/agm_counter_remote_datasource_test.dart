import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/agm_counter/data/datasources/agm_counter_remote_datasource.dart';
import 'package:pashboi/features/authenticated/agm_counter/domain/usecases/fetch_agm_counter_info_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  test('fetches AGM counter information for the given account', () async {
    final apiService = _MockApiService();
    final dataSource = AGMCounterRemoteDataSourceImpl(apiService: apiService);
    const props = FetchAGMCounterInfoProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      accountNo: 'SA-10',
    );
    final requestBody = {
      'UserName': props.email,
      'UID': props.userId,
      'MobileNumber': props.mobileNumber,
      'MobileNo': props.mobileNumber,
      'RolePermissionId': props.rolePermissionId,
      'ByUserId': props.userId,
      'EmployeeCode': props.employeeCode,
      'PersonId': props.personId,
      'AccountNo': props.accountNo,
      'RequestFrom': 'MobileApp',
    };
    when(
      () => apiService.post(ApiUrls.getAgmCounterInfo, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.getAgmCounterInfo),
        statusCode: HttpStatus.ok,
        data: {
          'Data': jsonEncode([
            {
              'SlNo': 3,
              'CounterNo': 'C-03',
              'LocationName': 'Main Hall',
              'AccountNo': 'SA-10',
              'FullName': 'Member Name',
            },
          ]),
        },
      ),
    );

    final result = await dataSource.fetchAGMCounterInfo(props);

    expect(result.counterNo, 'C-03');
    expect(result.accountNo, 'SA-10');
  });
}
