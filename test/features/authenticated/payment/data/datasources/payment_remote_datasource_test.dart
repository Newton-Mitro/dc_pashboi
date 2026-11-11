import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/payment/data/datasources/payment_remote_datasource.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/fetch_payment_services_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  late _MockApiService apiService;
  late PaymentRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockApiService();
    dataSource = PaymentRemoteDataSourceImpl(apiService: apiService);
  });

  test('fetches payment services for the authenticated user', () async {
    const props = FetchPaymentServicesProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
    );
    final requestBody = {
      'UserName': props.email,
      'UID': props.userId,
      'MobileNumber': props.mobileNumber,
      'MobileNo': props.mobileNumber,
      'RolePermission': props.rolePermissionId,
      'ByUserId': props.userId,
      'EmployeeCode': props.employeeCode,
      'PersonId': props.personId,
      'RequestFrom': 'MobileApp',
    };
    when(
      () => apiService.post(ApiUrls.getPaymentServices, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.getPaymentServices),
        statusCode: HttpStatus.ok,
        data: {
          'Data': jsonEncode([
            {
              'ServiceId': 4,
              'ServiceCode': 'UTIL-1',
              'ServiceName': 'Utility payment',
              'NotifyPerson': [],
            },
          ]),
        },
      ),
    );

    final services = await dataSource.fetchPaymentServices(props);

    expect(services, hasLength(1));
    expect(services.single.id, 4);
    expect(services.single.serviceName, 'Utility payment');
    verify(
      () => apiService.post(ApiUrls.getPaymentServices, data: requestBody),
    ).called(1);
  });
}
