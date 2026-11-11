import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/exceptions.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/services/network/network_info.dart';
import 'package:pashboi/features/authenticated/loan_payment/data/datasources/loan_payment_remote_datasource.dart';
import 'package:pashboi/features/authenticated/loan_payment/data/models/loan_payment_model.dart';
import 'package:pashboi/features/authenticated/loan_payment/data/repositories/loan_payment_repository_impl.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/usecases/fetch_loan_payment_usecase.dart';

class _MockRemoteDataSource extends Mock
    implements LoanPaymentRemoteDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remote;
  late LoanPaymentRepositoryImpl repository;
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
  final payment = LoanPaymentModel(
    id: 5,
    loanNumber: 'LN-205',
    loanRefundAmount: 5000,
    interestAmount: 300,
    loanFineAmount: 50,
    loanLpsAmount: 200,
    loanLpsRenewalFeeAmount: 25,
    shareFineAmount: 10,
  );

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = LoanPaymentRepositoryImpl(
      loanPaymentRemoteDataSource: remote,
      networkInfo: _MockNetworkInfo(),
    );
  });

  test('returns repayment details from the remote source', () async {
    when(() => remote.fetchLoanPayment(props)).thenAnswer((_) async => payment);

    final result = await repository.fetchLoanPayment(props);

    expect(
      result.fold((_) => false, (value) => identical(value, payment)),
      isTrue,
    );
    verify(() => remote.fetchLoanPayment(props)).called(1);
  });

  test('maps remote repayment errors to failures', () async {
    when(
      () => remote.fetchLoanPayment(props),
    ).thenThrow(ServerException(message: 'Repayment unavailable'));

    final result = await repository.fetchLoanPayment(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>().having(
        (failure) => failure.message,
        'message',
        'Repayment unavailable',
      ),
    );
  });
}
