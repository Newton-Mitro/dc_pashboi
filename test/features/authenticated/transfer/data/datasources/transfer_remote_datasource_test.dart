import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/transfer/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/submit_fund_transfer_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  late _MockApiService apiService;
  late TransferRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockApiService();
    dataSource = TransferRemoteDataSourceImpl(apiService: apiService);
  });

  test('submits a fund transfer with the expected request fields', () async {
    const props = SubmitFundTransferProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      amount: 500,
      otpRegId: 'otp-reg',
      otpValue: '123456',
      accountNumber: 'SA-1',
      toAccountNumber: 'SA-2',
      accountType: 'Savings',
      cardNumber: '1111222233334444',
      nameOnCard: 'member',
      cardPin: 'pin-hash',
    );
    final requestBody = {
      'AccHolder': props.accountNumber,
      'AccountNo': props.accountNumber,
      'AccTransfer': props.toAccountNumber,
      'AccType': props.accountType,
      'Amount': props.amount,
      'OTPRegId': props.otpRegId,
      'OTPValue': props.otpValue,
      'CardNo': props.cardNumber,
      'NameOnCard': props.nameOnCard,
      'SecretKey': props.cardPin,
      'UserName': props.email,
      'MobileNo': props.mobileNumber,
      'MobileNumber': props.mobileNumber,
      'RolePermissionId': props.rolePermissionId,
      'ByUserId': props.userId,
      'UID': props.userId,
      'EmployeeCode': props.employeeCode,
      'PersonId': props.personId,
      'RequestFrom': 'MobileApp',
    };
    when(
      () => apiService.post(ApiUrls.submitFundTransfer, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.submitFundTransfer),
        statusCode: HttpStatus.ok,
        data: {'Data': 'Transfer completed'},
      ),
    );

    final result = await dataSource.submitFundTransfer(props);

    expect(result, 'Transfer completed');
    verify(
      () => apiService.post(ApiUrls.submitFundTransfer, data: requestBody),
    ).called(1);
  });
}
