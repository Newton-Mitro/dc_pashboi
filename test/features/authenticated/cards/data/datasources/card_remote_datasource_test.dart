import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/cards/data/datasources/remote.datasource.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/get_my_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/issue_debit_card_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

Response<Map<String, dynamic>> _response(
  String path,
  Map<String, dynamic> data,
) => Response(
  requestOptions: RequestOptions(path: path),
  statusCode: HttpStatus.ok,
  data: data,
);

void main() {
  late _MockApiService apiService;
  late CardRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockApiService();
    dataSource = CardRemoteDataSourceImpl(apiService: apiService);
  });

  test('getMyCard sends the user request and parses the first card', () async {
    const props = GetMyCardUseCaseProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
    );
    when(
      () => apiService.post(
        ApiUrls.getMyCards,
        data: {
          'UserName': props.email,
          'MobileNumber': props.mobileNumber,
          'RolePermissionId': props.rolePermissionId,
          'ByUserId': props.userId,
          'EmployeeCode': props.employeeCode,
          'PersonId': props.personId,
          'UID': props.userId,
          'MobileNo': props.mobileNumber,
          'RequestFrom': 'MobileApp',
        },
      ),
    ).thenAnswer(
      (_) async => _response(ApiUrls.getMyCards, {
        'Data': jsonEncode([
          {
            'CardId': 4,
            'CardNo': '1111222233334444',
            'Name': 'Member',
            'CardsAccounts': [],
          },
        ]),
      }),
    );

    final card = await dataSource.getMyCard(props);

    expect(card.id, 4);
    expect(card.cardNumber, '1111222233334444');
    expect(card.nameOnCard, 'Member');
    verify(
      () => apiService.post(
        ApiUrls.getMyCards,
        data: {
          'UserName': props.email,
          'MobileNumber': props.mobileNumber,
          'RolePermissionId': props.rolePermissionId,
          'ByUserId': props.userId,
          'EmployeeCode': props.employeeCode,
          'PersonId': props.personId,
          'UID': props.userId,
          'MobileNo': props.mobileNumber,
          'RequestFrom': 'MobileApp',
        },
      ),
    ).called(1);
  });

  test(
    'issueDebitCard sends card selection and returns the response',
    () async {
      const props = IssueDebitCardUseCaseProps(
        email: 'member@example.com',
        userId: 7,
        rolePermissionId: 'role-1',
        personId: 3,
        employeeCode: 'EMP-3',
        mobileNumber: '01700000000',
        cardTypeCode: 'VISA',
        withCard: true,
      );
      when(
        () => apiService.post(
          ApiUrls.issueCard,
          data: {
            'UserName': props.email,
            'CardTypeCode': props.cardTypeCode,
            'WithCard': props.withCard,
            'MobileNumber': props.mobileNumber,
            'RolePermission': props.rolePermissionId,
            'ByUserId': props.userId,
            'EmployeeCode': props.employeeCode,
            'PersonId': props.personId,
            'RequestFrom': 'MobileApp',
          },
        ),
      ).thenAnswer(
        (_) async => _response(ApiUrls.issueCard, {'Data': 'Request received'}),
      );

      expect(await dataSource.issueDebitCard(props), 'Request received');
    },
  );

  test('getMyCard surfaces unsuccessful API responses as exceptions', () async {
    const props = GetMyCardUseCaseProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
    );
    when(
      () => apiService.post(
        ApiUrls.getMyCards,
        data: {
          'UserName': props.email,
          'MobileNumber': props.mobileNumber,
          'RolePermissionId': props.rolePermissionId,
          'ByUserId': props.userId,
          'EmployeeCode': props.employeeCode,
          'PersonId': props.personId,
          'UID': props.userId,
          'MobileNo': props.mobileNumber,
          'RequestFrom': 'MobileApp',
        },
      ),
    ).thenAnswer(
      (_) async => _response(ApiUrls.getMyCards, {
        'Data': '[]',
        'Status': 'failed',
        'Message': 'Card unavailable',
      }),
    );

    await expectLater(
      dataSource.getMyCard(props),
      throwsA(
        isA<ServerException>().having(
          (exception) => exception.message,
          'message',
          'Card unavailable',
        ),
      ),
    );
  });
}
