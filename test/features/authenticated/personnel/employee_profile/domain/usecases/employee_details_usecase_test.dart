import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/entities/employee_details_entity.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/repositories/employee_details_repository.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';

class _MockEmployeeDetailsRepository extends Mock
    implements EmployeeDetailsRepository {}

void main() {
  late _MockEmployeeDetailsRepository repository;
  late EmployeeDetailsUseCase useCase;
  const props = EmployeeDetailsProps(
    email: 'member@example.com',
    userId: 7,
    rolePermissionId: 'role-1',
    personId: 3,
    employeeCode: 'EMP-3',
    mobileNumber: '01700000000',
  );
  final employee = EmployeeDetailsEntity(
    id: 7,
    fullName: 'Member',
    registeredMobile: '01700000000',
    email: 'member@example.com',
    bloodGroup: 'N/A',
    gender: 'N/A',
    maritalStatus: 'N/A',
    religion: 'N/A',
    nationality: 'N/A',
    nid: 'N/A',
    rfIdCardNo: 'N/A',
    personPhoto: 'N/A',
    otherMobileNumber: 'N/A',
    employeeMobile: 'N/A',
    employeeEmail: 'N/A',
    supervisorName: 'N/A',
    employeeType: 'N/A',
    employeeCategory: 'N/A',
    employeeCategoryName: 'N/A',
    departmentName: 'N/A',
    designationName: 'N/A',
    branchName: 'N/A',
    joiningDate: 'N/A',
    employeeStatus: 'N/A',
    mobileNumber: '01700000000',
    employeeCode: 'EMP-3',
  );

  setUpAll(() {
    registerFallbackValue(props);
  });

  setUp(() {
    repository = _MockEmployeeDetailsRepository();
    useCase = EmployeeDetailsUseCase(employeeDetailsRepository: repository);
  });

  test('delegates employee detail requests to the repository', () async {
    when(
      () => repository.getEmployeeDetails(props),
    ).thenAnswer((_) async => Right<Failure, EmployeeDetailsEntity>(employee));

    final result = await useCase(props);

    expect(
      result.fold((_) => false, (value) => identical(value, employee)),
      isTrue,
    );
    verify(() => repository.getEmployeeDetails(props)).called(1);
  });
}
