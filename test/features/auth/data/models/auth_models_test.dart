import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/auth/data/models/auth_user_model.dart';
import 'package:pashboi/features/auth/data/models/role_permission_model.dart';
import 'package:pashboi/features/auth/data/models/user_model.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/entities/role_permission_entity.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import '../../../../mock.data/login.data.dart';

void main() {
  group('RolePermissionModel', () {
    test('parses API keys and serializes the permission', () {
      final model = RolePermissionModel.fromJson({
        'MenuId': 12,
        'parentMenuId': 3,
        'MenuName': 'Accounts',
        'ControllerName': 'Accounts',
        'Sort': 2,
        'ChkStatus': true,
        'MfsIcon': 'wallet',
        'RolePermissionIds': '45,46',
        'IsNewMenu': false,
      });

      expect(model.menuId, 12);
      expect(model.parentMenuId, 3);
      expect(model.menuName, 'Accounts');
      expect(model.controllerName, 'Accounts');
      expect(model.sort, 2);
      expect(model.chkStatus, isTrue);
      expect(model.mfsIcon, 'wallet');
      expect(model.rolePermissionIds, '45,46');
      expect(model.isNewMenu, isFalse);
      expect(model.toJson(), {
        'id': model.id,
        'MenuId': 12,
        'parentMenuId': 3,
        'MenuName': 'Accounts',
        'ControllerName': 'Accounts',
        'Sort': 2,
        'ChkStatus': true,
        'MfsIcon': 'wallet',
        'RolePermissionIds': '45,46',
        'IsNewMenu': false,
      });
    });

    test('uses defaults for absent optional API fields', () {
      final model = RolePermissionModel.fromJson({});

      expect(model.menuId, 0);
      expect(model.parentMenuId, 0);
      expect(model.menuName, isEmpty);
      expect(model.chkStatus, isFalse);
      expect(model.mfsIcon, isNull);
      expect(model.isNewMenu, isFalse);
    });
  });

  group('UserModel', () {
    test('maps user data and nested role permissions', () {
      final model = mockLoginUserModel;

      expect(model, isA<UserEntity>());
      expect(model.userId, 21);
      expect(model.personId, 63786);
      expect(model.loginEmail, 'john.doe@email.com');
      expect(model.userName, 'John Doe');
      expect(model.rolePermissions, isNotEmpty);
      expect(model.rolePermissions.first, isA<RolePermissionEntity>());

      final restored = UserModel.fromJson(model.toJson());
      expect(restored.userId, model.userId);
      expect(restored.personId, model.personId);
      expect(restored.loginEmail, model.loginEmail);
      expect(restored.userName, model.userName);
      expect(restored.rolePermissions, hasLength(model.rolePermissions.length));
      expect(
        restored.rolePermissions.first.menuId,
        model.rolePermissions.first.menuId,
      );
    });

    test('defaults absent user scalar values', () {
      final model = UserModel.fromJson({'RolePermissionModelList': []});

      expect(model.userId, 0);
      expect(model.personId, 0);
      expect(model.loginEmail, isEmpty);
      expect(model.roleId, isEmpty);
      expect(model.isNewMenu, isFalse);
      expect(model.rolePermissions, isEmpty);
    });
  });

  group('AuthUserModel', () {
    test('parses and serializes tokens with nested user data', () {
      final model = AuthUserModel.fromJson({
        'access_token': 'access-token',
        'refresh_token': 'refresh-token',
        'user': mockLoginUserModel.toJson(),
      });

      expect(model, isA<AuthUserEntity>());
      expect(model.accessToken, 'access-token');
      expect(model.refreshToken, 'refresh-token');
      expect(model.user.userId, mockLoginUserModel.userId);

      final restored = AuthUserModel.fromJson(model.toJson());
      expect(restored, model);
    });
  });
}
