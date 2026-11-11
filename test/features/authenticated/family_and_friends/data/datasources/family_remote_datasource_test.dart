import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/constants/api_urls.dart';
import 'package:pashboi/core/services/network/api_service.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/datasources/family_and_friend_remote.datasource.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/add_family_and_friend_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/get_family_and_friends_usecase.dart';

class _MockApiService extends Mock implements ApiService {}

void main() {
  late _MockApiService apiService;
  late FamilyAndFriendRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _MockApiService();
    dataSource = FamilyAndFriendRemoteDataSourceImpl(apiService: apiService);
  });

  test('fetches family members with the include-self option', () async {
    const props = GetFamilyAndFriendsProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      includeSelf: true,
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
      'IncludeSelf': true,
      'RequestFrom': 'MobileApp',
    };
    when(
      () => apiService.post(ApiUrls.getFamilyAndRelatives, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.getFamilyAndRelatives),
        statusCode: HttpStatus.ok,
        data: {
          'Data': jsonEncode([
            {
              'RelationMapId': 4,
              'RelationName': 'Sibling',
              'PersonId': 10,
              'ParentPersonId': 12,
              'FullName': 'Family Member',
              'Age': 28,
              'Gender': 'Female',
              'RequestStatus': 'Approved',
            },
          ]),
        },
      ),
    );

    final members = await dataSource.getFamilyAndFriends(props);

    expect(members, hasLength(1));
    expect(members.single.familyMemberName, 'Family Member');
    expect(members.single.relationName, 'Sibling');
  });

  test('adds a family member with child ID and relationship code', () async {
    const props = AddFamilyAndFriendProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      childPersonId: 12,
      relationTypeCode: 'S',
    );
    final requestBody = {
      'ChildPersonId': props.childPersonId,
      'RelationTypeCode': props.relationTypeCode,
      'UserName': props.email,
      'UID': props.userId,
      'ByUserId': props.userId,
      'RolePermissionId': props.rolePermissionId,
      'PersonId': props.personId,
      'EmployeeCode': props.employeeCode,
      'MobileNumber': props.mobileNumber,
      'MobileNo': props.mobileNumber,
      'RequestFrom': 'MobileApp',
    };
    when(
      () => apiService.post(ApiUrls.addFamilyOrRelative, data: requestBody),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ApiUrls.addFamilyOrRelative),
        statusCode: HttpStatus.ok,
        data: {'Data': 'Request submitted'},
      ),
    );

    expect(await dataSource.addFamilyAndFriend(props), 'Request submitted');
  });
}
