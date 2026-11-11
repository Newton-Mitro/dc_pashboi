import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/services/local_storage/local_storage.dart';
import 'package:pashboi/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:pashboi/features/auth/data/models/auth_user_model.dart';
import '../../../../mock.data/login.data.dart';

class _MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late _MockLocalStorage storage;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() {
    storage = _MockLocalStorage();
    dataSource = AuthLocalDataSourceImpl(localStorage: storage);
  });

  group('authentication user storage', () {
    final authUser = AuthUserModel(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      user: mockLoginUserModel,
    );

    test('stores the serialized auth user', () async {
      when(
        () => storage.saveString('auth_user', any()),
      ).thenAnswer((_) async {});

      await dataSource.setAuthUser(authUser);

      final captured =
          verify(() => storage.saveString('auth_user', captureAny())).captured;
      expect(jsonDecode(captured.single as String), authUser.toJson());
    });

    test('restores a stored auth user', () async {
      when(() => storage.getString('auth_user')).thenAnswer(
        (_) async => jsonEncode(authUser.toJson()),
      );

      final result = await dataSource.getAuthUser();

      expect(result, authUser);
    });

    test('throws CacheException when no auth user is stored', () async {
      when(() => storage.getString('auth_user')).thenAnswer((_) async => '');

      await expectLater(
        dataSource.getAuthUser(),
        throwsA(
          isA<CacheException>().having(
            (exception) => exception.message,
            'message',
            'User not found in local storage',
          ),
        ),
      );
    });

    test('clears the stored auth user', () async {
      when(() => storage.remove('auth_user')).thenAnswer((_) async {});

      await dataSource.clearAuthUser();

      verify(() => storage.remove('auth_user')).called(1);
    });
  });

  group('registered mobile storage', () {
    test('stores and reads the registered mobile number', () async {
      when(
        () => storage.saveString('reg_mobile', '+88017000000000'),
      ).thenAnswer((_) async {});
      when(
        () => storage.getString('reg_mobile'),
      ).thenAnswer((_) async => '+88017000000000');

      await dataSource.setRegisteredMobile('+88017000000000');
      final result = await dataSource.getRegisteredMobile();

      expect(result, '+88017000000000');
      verify(() => storage.saveString('reg_mobile', '+88017000000000'))
          .called(1);
      verify(() => storage.getString('reg_mobile')).called(1);
    });

    test('clears the registered mobile number', () async {
      when(() => storage.remove('reg_mobile')).thenAnswer((_) async {});

      await dataSource.clearRegisteredMobile();

      verify(() => storage.remove('reg_mobile')).called(1);
    });
  });
}
