import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/model/attendance_model.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/model/today_punch_model.dart';

void main() {
  test('AttendanceModel maps calendar attendance details', () {
    final model = AttendanceModel.fromJson({
      'Id': 'attendance-1',
      'Remarks': 'On time',
      'DepartmentName': 'Operations',
      'DesignationName': 'Officer',
      'BranchName': 'Central',
      'EmployeeName': 'Member',
      'AttendanceDate': '2025-06-18',
      'PunchArea': 'Main office',
      'ScheduleType': 'Regular',
      'Status': 'Present',
      'PunchIn': '09:00',
      'PunchOut': '17:00',
      'WorkHour': '8:00',
      'EmployeeCode': 'EMP-1',
    });

    expect(model.id, 'attendance-1');
    expect(model.attendanceDate, '2025-06-18');
    expect(model.status, 'Present');
    expect(model.punchIn, '09:00');
    expect(model.punchOut, '17:00');
    expect(model.employeeCode, 'EMP-1');
    expect(model.toJson()['Status'], 'Present');
    expect(model.toJson()['PunchIn'], '09:00');
    expect(model.toJson()['PunchOut'], '17:00');
    expect(model.props, containsAll(['09:00', '17:00']));
  });

  test('TodayPunchModel preserves check-in and query fields', () {
    final model = TodayPunchModel.fromJson({
      'Id': 1,
      'EmployeeName': 'Member',
      'DesignationName': 'Officer',
      'AttendanceDate': '2025-06-18',
      'PunchArea': 'Main office',
      'CheckInTime': '09:05',
      'DepartmentName': 'Operations',
      'EmployeeCode': 'EMP-1',
      'Remarks': '',
      'FromDate': '2025-06-18',
      'ToDate': '2025-06-18',
      'SearchText': 'EMP-1',
    });

    expect(model.id, 1);
    expect(model.checkInTime, '09:05');
    expect(model.employeeCode, 'EMP-1');
    expect(model.searchText, 'EMP-1');
    expect(model.toJson()['CheckInTime'], '09:05');
  });
}
