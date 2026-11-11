import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/loan_payment/data/datasources/loan_payment_remote_datasource.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/usecases/fetch_loan_payment_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  late _MockApiService apiService;
  late LoanPaymentRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockApiService();
    dataSource = LoanPaymentRemoteDataSourceImpl(apiService: apiService);
  });

  test(
    'fetches repayment amounts and attaches the requested loan number',
    () async {
      const props = FetchLoanPaymentProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        loanNumber: 'LN-205',
        interestDays: 45,
        interestRate: 8.5,
        loanBalance: 25000,
        loanRefundAmount: 5000,
        moduleCode: 'LN',
        issuedDate: '2024-01-01',
        lastPaidDate: '2025-01-01',
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
        'LoanNumber': props.loanNumber,
        'Days': props.interestDays,
        'InterestRate': props.interestRate,
        'IssuedAmount': props.loanBalance,
        'IssuedDate': props.issuedDate,
        'LastPaidDate': props.lastPaidDate,
        'LoanBalance': props.loanBalance,
        'LoanRefund': props.loanRefundAmount,
        'ModuleCode': props.moduleCode,
        'RequestFrom': 'MobileApp',
      };
      when(
        () => apiService.post(ApiUrls.fetchLoanRepayment, data: requestBody),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiUrls.fetchLoanRepayment),
          statusCode: HttpStatus.ok,
          data: {
            'Data': jsonEncode([
              {
                'LoanRefundAmount': 5000,
                'InterestAmount': 300,
                'LoanFine': 50,
                'LoanLpsAmount': 200,
                'LoanLpsRenewFeeAmount': 25,
                'ShareFine': 10,
              },
            ]),
          },
        ),
      );

      final model = await dataSource.fetchLoanPayment(props);

      expect(model.loanNumber, 'LN-205');
      expect(model.loanRefundAmount, 5000);
      expect(model.interestAmount, 300);
      expect(model.loanFineAmount, 50);
      verify(
        () => apiService.post(ApiUrls.fetchLoanRepayment, data: requestBody),
      ).called(1);
    },
  );
}
