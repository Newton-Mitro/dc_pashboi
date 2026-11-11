import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/data/models/employee_details_model.dart';

void main() {
  test('maps employee details and serializes the profile fields', () {
    final model = EmployeeDetailsModel.fromJson({
      'EmployeeId': 17,
      'FullName': 'Alex Member',
      'RegisteredMobile': '01700000000',
      'Email': 'alex@example.com',
      'BloodGroup': 'O+',
      'Gender': 'Other',
      'MaritalStatus': 'Single',
      'Religion': 'N/A',
      'Nationality': 'Bangladeshi',
      'NID': 'NID-1',
      'RfidCardNo': 'RFID-1',
      'PersonPhoto': 'photo.png',
      'OtherMobileNumber': '01800000000',
      'EmployeeMobile': '01900000000',
      'EmployeeEmail': 'employee@example.com',
      'SupervisorName': 'Supervisor',
      'EmployeeType': 'Permanent',
      'EmployeeCategory': 'Staff',
      'EmployeeCategoryName': 'General Staff',
      'DepartmentName': 'Operations',
      'DesignationName': 'Officer',
      'BranchName': 'Central',
      'JoiningDate': '2020-01-01',
      'EmployeeStatus': 'Active',
      'MobileNumber': '01700000000',
      'EmployeeCode': 'EMP-17',
    });

    expect(model.id, 17);
    expect(model.fullName, 'Alex Member');
    expect(model.email, 'alex@example.com');
    expect(model.departmentName, 'Operations');
    expect(model.employeeCode, 'EMP-17');
    expect(model.toJson()['FullName'], 'Alex Member');
    expect(model.toJson()['EmployeeCode'], 'EMP-17');
    expect(model.props, contains('Alex Member'));
  });

  test('uses documented fallbacks when profile fields are absent', () {
    final model = EmployeeDetailsModel.fromJson({});

    expect(model.id, 0);
    expect(model.fullName, 'N/A');
    expect(model.employeeCode, 'N/A');
  });
}
