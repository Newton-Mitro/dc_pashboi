import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/today_punch_entity.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/repositories/attendance_repository_interface.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';

class _MockAttendanceRepository extends Mock
    implements AttendanceRepositoryInterface {}

void main() {
  late _MockAttendanceRepository repository;
  late TodayPunchUseCase useCase;
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

  setUpAll(() {
    registerFallbackValue(props);
  });

  setUp(() {
    repository = _MockAttendanceRepository();
    useCase = TodayPunchUseCase(repositoryInterface: repository);
  });

  test('delegates the requested range and returns punch history', () async {
    final punches = <TodayPunchEntity>[];
    when(
      () => repository.todayPaunch(props),
    ).thenAnswer((_) async => Right<Failure, List<TodayPunchEntity>>(punches));

    final result = await useCase(props);

    expect(result, Right<Failure, List<TodayPunchEntity>>(punches));
    verify(() => repository.todayPaunch(props)).called(1);
  });
}
