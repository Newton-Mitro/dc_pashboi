import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/fallback_request_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_info_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_summery_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/leave_type_model.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/search_employee_model.dart';

Map<String, dynamic> _leaveBalanceJson() => {
  'LeaveTypeCode': 'ANL',
  'LeaveType': 'Annual',
  'EmployeeId': 12,
  'EmployeeCode': 'E-12',
  'TotalLeaveDays': 20.0,
  'Balance': 14.0,
  'TotalLeaveApplied': 6.0,
  'LastApplicationDate': '2025-02-01',
  'MaxBalance': 30,
  'MinimumNoticeDay': 2,
  'MaxLeaveAtATime': 10,
  'DocumentsRequiredDays': 5,
  'MaximumHourLeave': 4.0,
  'ApplyBeforeDays': 1,
  'IsFallbackRequired': true,
  'MaximumFallbackDays': 4,
  'IsEditable': true,
  'IsRejoinDateRequired': true,
  'EnableFutureDateApplication': true,
  'EnablePastDateApplication': false,
  'WithTime': false,
  'EnablePresentDateApplication': false,
  'RequireToDate': true,
};

Map<String, dynamic> _applicationJson() => {
  'LeaveTypeCode': 'ANL',
  'LeaveType': 'Annual',
  'LeaveApplicationId': 42,
  'EmployeeId': 12,
  'EmployeeName': 'Ada Member',
  'DepartmentName': 'Operations',
  'DesignationName': 'Officer',
  'ApplicationDate': '2025-02-01',
  'RejoiningDate': '2025-02-08',
  'TotalLeaveDays': 5,
  'Remarks': 'Family event',
  'SupervisorName': 'Manager',
  'FullName': 'Ada Member',
  'FallbackEmployeeCode': 'E-13',
  'FallbackPersonId': 13,
  'FallbackPersonName': 'Grace Member',
  'CurrentStage': 'Manager',
  'StageCode': 'MGR',
  'FromDate': '2025-02-03',
  'ToDate': '2025-02-07',
  'EmployeeCode': 'E-12',
};

void main() {
  test(
    'LeaveApplicationRequestModel parses and serializes application details',
    () {
      final model = LeaveApplicationRequestModel.fromJson(_applicationJson());

      expect(model.id, 'ANL');
      expect(model.leaveApplicationId, 42);
      expect(model.totalLeaveDays, 5.0);
      expect(model.fromDate, DateTime(2025, 2, 3));
      expect(model.toDate, DateTime(2025, 2, 7));
      expect(model.toJson()['LeaveApplicationId'], 42);
      expect(model.toJson()['FromDate'], '2025-02-03T00:00:00.000');
      expect(model.props, contains('Family event'));
    },
  );

  test(
    'LeaveApplicationRequestModel applies absent optional JSON defaults',
    () {
      final model = LeaveApplicationRequestModel.fromJson({
        'FromDate': '2025-01-01',
        'ToDate': '2025-01-01',
      });

      expect(model.leaveType, '');
      expect(model.leaveApplicationId, 0);
      expect(model.employeeName, '');
      expect(model.totalLeaveDays, 0.0);
    },
  );

  test('LeaveInfoModel maps balance configuration and round-trips JSON', () {
    final model = LeaveInfoModel.fromJson(_leaveBalanceJson());

    expect(model.id, 'ANL');
    expect(model.balance, 14.0);
    expect(model.isFallbackRequired, isTrue);
    expect(model.requireToDate, isTrue);
    expect(model.toJson()['EmployeeId'], 12);
    expect(model.toJson()['RequireToDate'], isTrue);
    expect(model.props, contains('E-12'));
  });

  test('LeaveSummeryModel maps summary information', () {
    final model = LeaveSummeryModel.fromJson(_leaveBalanceJson());

    expect(model.leaveTypeCode, 'ANL');
    expect(model.totalLeaveApplied, 6.0);
    expect(model.maximumFallbackDays, 4);
    expect(model.toJson()['Balance'], 14.0);
    expect(model.props, contains(6.0));
  });

  test('LeaveTypeBalanceDto holds its leave info and summaries', () {
    final info = LeaveInfoModel.fromJson(_leaveBalanceJson());
    final summary = LeaveSummeryModel.fromJson(_leaveBalanceJson());
    final dto = LeaveTypeBalanceDto(leaveInfo: info, leaveSummary: [summary]);

    expect(dto.leaveInfo, same(info));
    expect(dto.leaveSummary, [summary]);
  });

  test('LeaveTypeModel parses, defaults, and serializes leave types', () {
    final model = LeaveTypeModel.fromJson({
      'LeaveTypeCode': 'SICK',
      'LeaveType': 'Sick leave',
    });
    final defaults = LeaveTypeModel.fromJson({});

    expect(model.id, 'SICK');
    expect(model.leaveType, 'Sick leave');
    expect(model.toJson(), {
      'LeaveTypeCode': 'SICK',
      'LeaveType': 'Sick leave',
    });
    expect(defaults.leaveType, 'N/A');
  });

  test(
    'SearchEmployeeModel parses dates, defaults invalid dates, and serializes',
    () {
      final model = SearchEmployeeModel.fromJson({
        'FullName': 'Grace Member',
        'DateOfBirth': '1990-04-05',
        'EmployeeId': 13,
        'PersonId': 14,
        'EmployeeCode': 13,
      });
      final defaults = SearchEmployeeModel.fromJson({'DateOfBirth': 'invalid'});

      expect(model.fullName, 'Grace Member');
      expect(model.dateOfBirth, DateTime(1990, 4, 5));
      expect(model.employeeId, 13);
      expect(model.personId, 14);
      expect(model.employeeCode, '13');
      expect(model.toJson()['EmployeeCode'], '13');
      expect(defaults.dateOfBirth, DateTime(1970));
      expect(defaults.employeeCode, 'N/A');
    },
  );
}
