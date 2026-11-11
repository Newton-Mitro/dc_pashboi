import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/model/attendance_model.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/model/today_punch_model.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/data/repositories/attendance_repository_interface_impl.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';

class _MockRemoteDataSource extends Mock
    implements AttendanceRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late AttendanceRepositoryInterfaceImpl repository;
  const props = TodayPunchProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-01',
    toDate: '2025-06-30',
  );
  const attendanceProps = AttendanceProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-01',
    toDate: '2025-06-30',
  );
  final attendanceRecord = AttendanceModel(
    id: 'attendance-1',
    remarks: 'On time',
    departmentName: 'Operations',
    designationName: 'Officer',
    branchName: 'Central',
    employeeName: 'Member',
    attendanceDate: '2025-06-18',
    punchArea: 'Office',
    scheduleType: 'Regular',
    status: 'Present',
    punchIn: '09:00',
    punchOut: '17:00',
    workHour: '8:00',
    employeeCode: 'EMP-3',
  );
  final punch = TodayPunchModel(
    id: 5,
    employeeName: 'Member',
    designationName: 'Officer',
    attendanceDate: '2025-06-18',
    punchArea: 'Office',
    checkInTime: '09:00',
    departmentName: 'Operations',
    employeeCode: 'EMP-3',
    remarks: '',
    fromDate: '2025-06-01',
    toDate: '2025-06-30',
    searchText: '',
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = AttendanceRepositoryInterfaceImpl(
      attendanceRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('todayPaunch returns records from the remote source', () async {
    when(() => remote.fetchPaunch(props)).thenAnswer((_) async => [punch]);

    final result = await repository.todayPaunch(props);

    expect(
      result.fold((_) => false, (items) => identical(items.single, punch)),
      isTrue,
    );
    verify(() => remote.fetchPaunch(props)).called(1);
  });

  test('todayPaunch maps remote exceptions to failures', () async {
    when(
      () => remote.fetchPaunch(props),
    ).thenThrow(ServerException(message: 'Punch history unavailable'));

    final result = await repository.todayPaunch(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Punch history unavailable',
      ),
    );
  });

  test(
    'getAttendance returns calendar records from the remote source',
    () async {
      when(
        () => remote.fetchAttendance(attendanceProps),
      ).thenAnswer((_) async => [attendanceRecord]);

      final result = await repository.getAttendance(attendanceProps);

      expect(
        result.fold(
          (_) => false,
          (records) => identical(records.single, attendanceRecord),
        ),
        isTrue,
      );
      verify(() => remote.fetchAttendance(attendanceProps)).called(1);
    },
  );

  test('getAttendance maps remote exceptions to failures', () async {
    when(
      () => remote.fetchAttendance(attendanceProps),
    ).thenThrow(ServerException(message: 'Attendance unavailable'));

    final result = await repository.getAttendance(attendanceProps);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Attendance unavailable',
      ),
    );
  });
}
