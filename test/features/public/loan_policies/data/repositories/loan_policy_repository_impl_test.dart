import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/loan_policies/data/data_sources/remote_datasource.dart';
import 'package:pashboi/features/public/loan_policies/data/models/loan_policy_model.dart';
import 'package:pashboi/features/public/loan_policies/data/repositories/loan_policy_repository_impl.dart';
import 'package:pashboi/features/public/loan_policies/domain/usecases/fetch_loan_policy_usecase.dart';

class _MockLoanPolicyRemoteDataSource extends Mock
    implements LoanPolicyRemoteDataSource {}

void main() {
  late _MockLoanPolicyRemoteDataSource remote;
  late LoanPolicyRepositoryImpl repository;
  final props = FetchLoanPolicyProps(categoryId: 'category-1');
  final policies = [
    LoanPolicyModel.fromJson({
      'id': 'policy-1',
      'title': 'Personal Loan',
      'order': 3,
      'product_categories_id': 'category-1',
      'created_at': '2025-01-01T10:00:00.000Z',
      'updated_at': '2025-01-02T10:00:00.000Z',
    }),
  ];

  setUp(() {
    remote = _MockLoanPolicyRemoteDataSource();
    repository = LoanPolicyRepositoryImpl(loanPolicyRemoteDataSource: remote);
  });

  test('returns policies fetched for the requested category', () async {
    when(
      () => remote.fetchLoanPoliciesByCategoryId(props),
    ).thenAnswer((_) async => policies);

    final result = await repository.findLoanPoliciesByCategoryId(props);

    expect(
      result.fold(
        (_) => false,
        (items) => identical(items.single, policies.single),
      ),
      isTrue,
    );
    verify(() => remote.fetchLoanPoliciesByCategoryId(props)).called(1);
  });

  test('maps network exceptions to network failures', () async {
    when(
      () => remote.fetchLoanPoliciesByCategoryId(props),
    ).thenThrow(const SocketException('No route to host'));

    final result = await repository.findLoanPoliciesByCategoryId(props);

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });
}
