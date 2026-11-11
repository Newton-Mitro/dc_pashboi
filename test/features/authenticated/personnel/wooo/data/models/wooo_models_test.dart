import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_data_model.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/data/model/wooo_type_model.dart';

void main() {
  group('WoooTypeModel', () {
    test('maps API fields to the type entity and serializes them', () {
      final model = WoooTypeModel.fromJson({
        'WoooTypeId': 2,
        'WoooTypeName': 'Remote work',
        'WoooTypeCode': 'REMOTE',
        'BackDateDays': 3,
        'FromDate': '2025-06-01',
        'ToDate': '2025-06-30',
      });

      expect(model.id, 2);
      expect(model.woooTypeId, 2);
      expect(model.woooTypeName, 'Remote work');
      expect(model.woooTypeCode, 'REMOTE');
      expect(model.backDateDays, 3);
      expect(model.toJson(), {
        'WoooTypeId': 2,
        'WoooTypeName': 'Remote work',
        'WoooTypeCode': 'REMOTE',
        'BackDateDays': 3,
        'FromDate': '2025-06-01',
        'ToDate': '2025-06-30',
      });
      expect(model.props, containsAll([2, 'Remote work', 'REMOTE', 3]));
    });

    test('uses defaults for absent optional API values', () {
      final model = WoooTypeModel.fromJson({'WoooTypeId': 0});

      expect(model.id, 0);
      expect(model.woooTypeId, 0);
      expect(model.woooTypeName, '');
      expect(model.woooTypeCode, '');
      expect(model.backDateDays, 0);
      expect(model.fromDate, '');
      expect(model.toDate, '');
    });
  });

  group('WoooDataModel', () {
    test('maps WOOO request details and serializes API fields', () {
      final model = WoooDataModel.fromJson({
        'EmployeeWoooId': 5,
        'totalRecords': 1,
        'WoooTypeCode': 'REMOTE',
        'RejoiningDate': '2025-06-04',
        'Reason': 'Working remotely',
        'isHourly': true,
        'ByMMS': true,
        'AppliedBy': 7,
        'RejectedBy': 0,
        'TotalDays': 2,
        'TotalHour': '4',
        'ApplicationDate': '2025-06-01',
        'WoooTypeId': 2,
        'WoooType': 'Remote work',
        'IsEditable': true,
        'IsSupervisorTreeWise': false,
        'RegisteredStatus': true,
        'EmployeeId': 7,
        'EmployeeName': 'Member',
        'Status': 'Pending',
        'FromDate': '2025-06-02',
        'ToDate': '2025-06-03',
      });

      expect(model.id, 5);
      expect(model.employeeWoooId, 5);
      expect(model.reason, 'Working remotely');
      expect(model.isHourly, isTrue);
      expect(model.byMMS, isTrue);
      expect(model.status, 'Pending');
      expect(model.props, containsAll([5, 'REMOTE', 'Pending']));
      expect(model.toJson(), {
        'Id': 5,
        'EmployeeWoooId': 5,
        'totalRecords': 1,
        'WoooTypeCode': 'REMOTE',
        'RejoiningDate': '2025-06-04',
        'Reason': 'Working remotely',
        'IsHourly': true,
        'ByMMS': true,
        'AppliedBy': 7,
        'RejectedBy': 0,
        'TotalDays': 2,
        'TotalHour': '4',
        'ApplicationDate': '2025-06-01',
        'WoooTypeId': 2,
        'WoooType': 'Remote work',
        'IsEditable': true,
        'IsSupervisorTreeWise': false,
        'RegisteredStatus': true,
        'EmployeeId': 7,
        'EmployeeName': 'Member',
        'Status': 'Pending',
        'FromDate': '2025-06-02',
        'ToDate': '2025-06-03',
      });
    });

    test('defaults hourly and MMS flags to false', () {
      final model = WoooDataModel.fromJson({
        'EmployeeWoooId': 5,
        'totalRecords': 1,
        'WoooTypeCode': 'REMOTE',
        'RejoiningDate': '',
        'Reason': '',
        'AppliedBy': 0,
        'RejectedBy': 0,
        'TotalDays': 0,
        'TotalHour': '0',
        'ApplicationDate': '',
        'WoooTypeId': 0,
        'WoooType': '',
        'IsEditable': false,
        'IsSupervisorTreeWise': false,
        'RegisteredStatus': false,
        'EmployeeId': 0,
        'EmployeeName': '',
        'Status': '',
        'FromDate': '',
        'ToDate': '',
      });

      expect(model.isHourly, isFalse);
      expect(model.byMMS, isFalse);
    });
  });
}
