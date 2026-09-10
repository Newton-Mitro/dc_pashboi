part of 'deposit_policy_bloc.dart';

sealed class DepositPolicyEvent extends Equatable {
  const DepositPolicyEvent();
  @override
  List<Object?> get props => [];
}

class FetchDepositPolicyEvent extends DepositPolicyEvent {
  const FetchDepositPolicyEvent();
}
