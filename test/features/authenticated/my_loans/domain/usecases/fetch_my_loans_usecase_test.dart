import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/repositories/loan_repository.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';

class _MockRepository extends Mock implements LoanRepository {}

void main() {
  test('forwards the request and returns repository result', () async {
    final repository = _MockRepository();
    final useCase = FetchMyLoansUseCase(loanRepository: repository);
    const props = FetchMyLoansProps(
      email: 'member@example.com',
      userId: 1,
      rolePermissionId: 'role-1',
      personId: 2,
      employeeCode: 'EMP-1',
      mobileNumber: '01700000000',
    );
    final loans = <LoanAccountEntity>[];
    when(
      () => repository.fetchMyLoans(props),
    ).thenAnswer((_) async => Right<Failure, List<LoanAccountEntity>>(loans));

    final result = await useCase.call(props);

    expect(result, Right<Failure, List<LoanAccountEntity>>(loans));
    verify(() => repository.fetchMyLoans(props)).called(1);
  });
}
