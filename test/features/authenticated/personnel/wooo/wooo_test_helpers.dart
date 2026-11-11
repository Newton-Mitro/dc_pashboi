import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_data_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_type_model.dart';

final testWoooUser = UserEntity(
  userId: 7,
  personId: 3,
  loginEmail: 'member@example.com',
  roleId: 'role-1',
  roleName: 'Member',
  userName: 'Member',
  branchCode: '01',
  regMobile: '01700000000',
  address: '',
  organizationCode: '',
  deviceId: 1,
  employeeCode: 'EMP-3',
  isNewMenu: false,
  rolePermissions: const [],
);

final testWoooAuthUser = AuthUserEntity(
  accessToken: 'access-token',
  refreshToken: 'refresh-token',
  user: testWoooUser,
);

WoooTypeModel makeWoooTypeModel({int id = 2, String name = 'Remote work'}) =>
    WoooTypeModel(
      id: id,
      woooTypeId: id,
      woooTypeName: name,
      woooTypeCode: 'REMOTE',
      backDateDays: 3,
      fromDate: '2025-06-01',
      toDate: '2025-06-30',
    );

WoooDataModel makeWoooDataModel({int id = 5, String status = 'Pending'}) =>
    WoooDataModel(
      id: id,
      employeeWoooId: id,
      totalRecords: 1,
      woooTypeCode: 'REMOTE',
      rejoiningDate: '2025-06-04',
      reason: 'Working remotely',
      isHourly: false,
      byMMS: false,
      appliedBy: 7,
      rejectedBy: 0,
      totalDays: 2,
      totalHour: '0',
      applicationDate: '2025-06-01',
      woooTypeId: 2,
      woooType: 'Remote work',
      isEditable: true,
      isSupervisorTreeWise: false,
      registeredStatus: true,
      employeeId: 7,
      employeeName: 'Member',
      status: status,
      fromDate: '2025-06-02',
      toDate: '2025-06-03',
    );
