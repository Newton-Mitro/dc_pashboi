import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/beneficiaries/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/add_beneficiary_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/fetch_beneficiaries_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/remove_beneficiary_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  late _MockApiService apiService;
  late BeneficiaryRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockApiService();
    dataSource = BeneficiaryRemoteDataSourceImpl(apiService: apiService);
  });

  test('fetches and parses beneficiaries for the current member', () async {
    const props = FetchBeneficiariesProps(
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
      () => apiService.post(ApiUrls.getBeneficiaries, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.getBeneficiaries),
        statusCode: HttpStatus.ok,
        data: {
          'Data': jsonEncode([
            {'Id': 2, 'PersonName': 'Payee', 'AccountNo': 'SA-2'},
          ]),
        },
      ),
    );

    final beneficiaries = await dataSource.fetchBeneficiaries(props);

    expect(beneficiaries, hasLength(1));
    expect(beneficiaries.single.name, 'Payee');
    expect(beneficiaries.single.accountNumber, 'SA-2');
    verify(
      () => apiService.post(ApiUrls.getBeneficiaries, data: requestBody),
    ).called(1);
  });

  test('adds a beneficiary with the supplied account details', () async {
    const props = AddBeneficiaryProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      beneficiaryName: 'Payee',
      beneficiaryAccountNumber: 'SA-2',
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
      'AccountNo': props.beneficiaryAccountNumber,
      'AccountHolderName': props.beneficiaryName,
      'RequestFrom': 'MobileApp',
    };
    when(
      () => apiService.post(ApiUrls.addBeneficiary, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.addBeneficiary),
        statusCode: HttpStatus.ok,
        data: {'Data': 'Beneficiary added'},
      ),
    );

    expect(await dataSource.addBeneficiary(props), 'Beneficiary added');
  });

  test('removes beneficiary by account number', () async {
    const props = RemoveBeneficiaryProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      beneficiaryAccountNumber: 'SA-2',
    );
    when(
      () => apiService.post(
        ApiUrls.removeBeneficiary,
        data: {
          'UserName': props.email,
          'UID': props.userId,
          'MobileNumber': props.mobileNumber,
          'MobileNo': props.mobileNumber,
          'RolePermission': props.rolePermissionId,
          'ByUserId': props.userId,
          'EmployeeCode': props.employeeCode,
          'PersonId': props.personId,
          'AccountNo': props.beneficiaryAccountNumber,
          'RequestFrom': 'MobileApp',
        },
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.removeBeneficiary),
        statusCode: HttpStatus.ok,
        data: {'Data': 'Beneficiary removed'},
      ),
    );

    expect(await dataSource.removeBeneficiary(props), 'Beneficiary removed');
  });
}
