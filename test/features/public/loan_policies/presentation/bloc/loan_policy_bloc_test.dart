import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/loan_policies/domain/entites/loan_policy_entity.dart';
import 'package:pashboi/features/public/loan_policies/domain/usecases/fetch_loan_policy_usecase.dart';
import 'package:pashboi/features/public/loan_policies/presentation/bloc/loan_policy_bloc.dart';

class _MockFetchLoanPolicyUseCase extends Mock
    implements FetchLoanPolicyUseCase {}

void main() {
  late _MockFetchLoanPolicyUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FetchLoanPolicyProps(categoryId: 'fallback'));
  });

  setUp(() {
    useCase = _MockFetchLoanPolicyUseCase();
  });

  LoanPolicyBloc buildBloc() => LoanPolicyBloc(fetchLoanPolicyUseCase: useCase);

  blocTest<LoanPolicyBloc, LoanPolicyState>(
    'emits loading then loaded loan policies',
    setUp: () {
      when(() => useCase.call(any())).thenAnswer(
        (_) async => const Right<Failure, List<LoanPolicyEntity>>([]),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchLoanPolicyEvent()),
    expect:
        () => [
          const LoanPolicyLoading(),
          const LoanPolicySuccess(loanPolicies: []),
        ],
    verify: (_) {
      final props =
          verify(() => useCase.call(captureAny())).captured.single
              as FetchLoanPolicyProps;
      expect(props.categoryId, '95876bf4-5cc9-4ab7-9884-01b4ca58bf2b');
    },
  );

  blocTest<LoanPolicyBloc, LoanPolicyState>(
    'emits an error when loan policies cannot be loaded',
    setUp: () {
      when(() => useCase.call(any())).thenAnswer(
        (_) async => const Left<Failure, List<LoanPolicyEntity>>(
          ServerFailure(message: 'Loan policies unavailable'),
        ),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchLoanPolicyEvent()),
    expect:
        () => [
          const LoanPolicyLoading(),
          const LoanPolicyerror(error: 'Loan policies unavailable'),
        ],
  );
}
