part of 'deposit_policy_bloc.dart';

sealed class DepositPolicyState extends Equatable {
  const DepositPolicyState();

  @override
  List<Object?> get props => [];
}

final class DepositPolicyInitial extends DepositPolicyState {
  const DepositPolicyInitial();
}

final class DepositProductLoading extends DepositPolicyState {
  const DepositProductLoading();
}

final class DepositPolicySuccess extends DepositPolicyState {
  final List<DepositPolicyEntity> depositPolicies;
  const DepositPolicySuccess({required this.depositPolicies});

  @override
  List<Object?> get props => [depositPolicies];
}

final class DepositPolicyError extends DepositPolicyState {
  final String error;
  const DepositPolicyError({required this.error});

  @override
  List<Object?> get props => [error];
}
