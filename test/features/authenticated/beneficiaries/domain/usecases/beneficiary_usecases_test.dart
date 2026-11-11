import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/entities/beneficiary_entity.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/repositories/beneficiary_repository.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/add_beneficiary_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/fetch_beneficiaries_usecase.dart';
import 'package:pashboi/features/authenticated/beneficiaries/domain/usecases/remove_beneficiary_usecase.dart';

class _MockRepository extends Mock implements BeneficiaryRepository {}

void main() {
  late _MockRepository repository;

  setUp(() {
    repository = _MockRepository();
  });

  test('FetchBeneficiariesUseCase forwards the request', () async {
    final useCase = FetchBeneficiariesUseCase(
      beneficiaryRepository: repository,
    );
    const props = FetchBeneficiariesProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
    );
    final beneficiaries = <BeneficiaryEntity>[];
    when(() => repository.fetchBeneficiaries(props)).thenAnswer(
      (_) async => Right<Failure, List<BeneficiaryEntity>>(beneficiaries),
    );

    final result = await useCase.call(props);

    expect(result, Right<Failure, List<BeneficiaryEntity>>(beneficiaries));
    verify(() => repository.fetchBeneficiaries(props)).called(1);
  });

  test('AddBeneficiaryUseCase forwards account details', () async {
    final useCase = AddBeneficiaryUseCase(beneficiaryRepository: repository);
    const props = AddBeneficiaryProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      beneficiaryName: 'Payee',
      beneficiaryAccountNumber: 'SA-2',
    );
    when(
      () => repository.addBeneficiary(props),
    ).thenAnswer((_) async => const Right<Failure, String>('Added'));

    final result = await useCase.call(props);

    expect(result, const Right<Failure, String>('Added'));
    verify(() => repository.addBeneficiary(props)).called(1);
  });

  test('RemoveBeneficiaryUseCase forwards the account number', () async {
    final useCase = RemoveBeneficiaryUseCase(beneficiaryRepository: repository);
    const props = RemoveBeneficiaryProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      beneficiaryAccountNumber: 'SA-2',
    );
    when(
      () => repository.removeBeneficiary(props),
    ).thenAnswer((_) async => const Right<Failure, String>('Removed'));

    final result = await useCase.call(props);

    expect(result, const Right<Failure, String>('Removed'));
    verify(() => repository.removeBeneficiary(props)).called(1);
  });
}
