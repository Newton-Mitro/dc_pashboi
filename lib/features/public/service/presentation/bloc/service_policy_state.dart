import 'package:equatable/equatable.dart';
import 'package:pashboi/features/public/service/domain/enities/service_policy_entity.dart';

sealed class ServicePolicyState extends Equatable {
  const ServicePolicyState();

  @override
  List<Object?> get props => [];
}

final class ServicePolicyInitial extends ServicePolicyState {
  const ServicePolicyInitial();
}

final class ServiceProductLoading extends ServicePolicyState {
  const ServiceProductLoading();
}

final class ServicePolicySuccess extends ServicePolicyState {
  final List<ServicePolicyEntity> servicePolicies;
  const ServicePolicySuccess({required this.servicePolicies});

  @override
  List<Object?> get props => [servicePolicies];
}

final class ServicePolicyError extends ServicePolicyState {
  final String error;
  const ServicePolicyError({required this.error});

  @override
  List<Object?> get props => [error];
}
