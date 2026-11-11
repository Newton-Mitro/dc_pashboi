import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/datasources/relationship_remote_datasource.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/fetch_relationships_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  test('fetches relationship options for the requested gender', () async {
    final apiService = _MockApiService();
    final dataSource = RelationshipRemoteDataSourceImpl(apiService: apiService);
    const props = FetchRelationshipsProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      gender: 'Female',
    );
    final requestBody = {
      'UserName': props.email,
      'UID': props.userId,
      'ByUserId': props.userId,
      'RolePermissionId': props.rolePermissionId,
      'PersonId': props.personId,
      'EmployeeCode': props.employeeCode,
      'MobileNumber': props.mobileNumber,
      'MobileNo': props.mobileNumber,
      'RelationTypeCode': '',
      'Gender': props.gender,
      'RequestFrom': 'MobileApp',
    };
    when(
      () => apiService.post(ApiUrls.getRelationshipTypes, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.getRelationshipTypes),
        statusCode: HttpStatus.ok,
        data: {
          'Data': jsonEncode([
            {
              'Id': 2,
              'RelationName': 'Parent',
              'Gender': 'Female',
              'RelationTypeCode': 'P',
            },
          ]),
        },
      ),
    );

    final relationships = await dataSource.fetchRelationships(props);

    expect(relationships, hasLength(1));
    expect(relationships.single.name, 'Parent');
    expect(relationships.single.code, 'P');
  });
}
