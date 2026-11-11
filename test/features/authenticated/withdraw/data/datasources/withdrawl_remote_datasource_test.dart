import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/withdraw/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/withdraw/domain/usecases/generate_withdrawl_qr_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  late _MockApiService apiService;
  late WithdrawlRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockApiService();
    dataSource = WithdrawlRemoteDataSourceImpl(apiService: apiService);
  });

  test('generates a withdrawal QR with all verification fields', () async {
    const props = GenerateWithdrawlQrProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      amount: 1000,
      otpRegId: 'otp-reg',
      otpValue: '456789',
      accountNumber: 'SA-1',
      cardNumber: '1111222233334444',
      nameOnCard: 'member',
      cardPin: 'pin-hash',
    );
    final requestBody = {
      'Amount': props.amount,
      'OTPRegId': props.otpRegId,
      'OTPValue': props.otpValue,
      'CardNo': props.cardNumber,
      'NameOnCard': props.nameOnCard,
      'SecretKey': props.cardPin,
      'AccountNo': props.accountNumber,
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
      () => apiService.post(ApiUrls.generateWithdrawalOTQR, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.generateWithdrawalOTQR),
        statusCode: HttpStatus.ok,
        data: {'Data': 'qr-payload'},
      ),
    );

    expect(await dataSource.generateWithdrawlQr(props), 'qr-payload');
    verify(
      () => apiService.post(ApiUrls.generateWithdrawalOTQR, data: requestBody),
    ).called(1);
  });
}
