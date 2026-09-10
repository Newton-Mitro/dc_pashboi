part of 'service_policy_bloc.dart';

sealed class ServicePolicyEvent extends Equatable {
  const ServicePolicyEvent();

  @override
  List<Object?> get props => [];
}

class FetchServicePolicyEvent extends ServicePolicyEvent {
  const FetchServicePolicyEvent();
}
