import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/repositories/attendance_repository_interface.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';

class _MockAttendanceRepository extends Mock
    implements AttendanceRepositoryInterface {}

void main() {
  late _MockAttendanceRepository repository;
  late AttendanceUseCase useCase;
  const props = AttendanceProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
    fromDate: '2025-06-01',
    toDate: '2025-06-30',
  );

  setUpAll(() {
    registerFallbackValue(props);
  });

  setUp(() {
    repository = _MockAttendanceRepository();
    useCase = AttendanceUseCase(attendanceRepository: repository);
  });

  test('delegates the attendance date range to its repository', () async {
    final attendance = <GetAttendanceEntities>[];
    when(() => repository.getAttendance(props)).thenAnswer(
      (_) async => Right<Failure, List<GetAttendanceEntities>>(attendance),
    );

    final result = await useCase(props);

    expect(result, Right<Failure, List<GetAttendanceEntities>>(attendance));
    verify(() => repository.getAttendance(props)).called(1);
  });
}
