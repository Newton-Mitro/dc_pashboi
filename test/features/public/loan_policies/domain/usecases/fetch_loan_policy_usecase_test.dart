import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/loan_policies/domain/entites/loan_policy_entity.dart';
import 'package:pashboi/features/public/loan_policies/domain/repositories/loan_policy_repository.dart';
import 'package:pashboi/features/public/loan_policies/domain/usecases/fetch_loan_policy_usecase.dart';

class _MockLoanPolicyRepository extends Mock implements LoanPolicyRepository {}

void main() {
  late _MockLoanPolicyRepository repository;
  late FetchLoanPolicyUseCase useCase;
  final props = FetchLoanPolicyProps(categoryId: 'category-1');

  setUp(() {
    repository = _MockLoanPolicyRepository();
    useCase = FetchLoanPolicyUseCase(loanPolicyRepository: repository);
  });

  test('delegates fetching policy data for the requested category', () async {
    final policies = <LoanPolicyEntity>[];
    when(
      () => repository.findLoanPoliciesByCategoryId(props),
    ).thenAnswer((_) async => Right<Failure, List<LoanPolicyEntity>>(policies));

    final result = await useCase(props);

    expect(result, Right<Failure, List<LoanPolicyEntity>>(policies));
    verify(() => repository.findLoanPoliciesByCategoryId(props)).called(1);
  });
}
