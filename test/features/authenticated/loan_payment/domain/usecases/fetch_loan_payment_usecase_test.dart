import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/entities/loan_payment_entity.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/repositories/loan_payment_repository.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/usecases/fetch_loan_payment_usecase.dart';

class _MockRepository extends Mock implements LoanPaymentRepository {}

void main() {
  test('passes repayment request to the repository', () async {
    final repository = _MockRepository();
    final useCase = FetchLoanPaymentUseCase(loanPaymentRepository: repository);
    const props = FetchLoanPaymentProps(
      email: 'member@example.com',
      userId: 7,
      rolePermissionId: 'role-1',
      personId: 3,
      employeeCode: 'EMP-3',
      mobileNumber: '01700000000',
      loanNumber: 'LN-205',
      interestDays: 45,
      interestRate: 8.5,
      loanBalance: 25000,
      loanRefundAmount: 5000,
      moduleCode: 'LN',
      issuedDate: '2024-01-01',
      lastPaidDate: '2025-01-01',
    );
    final payment = LoanPaymentEntity(
      id: 5,
      loanNumber: 'LN-205',
      loanRefundAmount: 5000,
      interestAmount: 300,
      loanFineAmount: 50,
      loanLpsAmount: 200,
      loanLpsRenewalFeeAmount: 25,
      shareFineAmount: 10,
    );
    when(
      () => repository.fetchLoanPayment(props),
    ).thenAnswer((_) async => Right<Failure, LoanPaymentEntity>(payment));

    final result = await useCase.call(props);

    expect(
      result.fold((_) => false, (value) => identical(value, payment)),
      isTrue,
    );
    verify(() => repository.fetchLoanPayment(props)).called(1);
  });
}
