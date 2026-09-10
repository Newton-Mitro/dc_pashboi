part of 'service_center_bloc.dart';

sealed class ServiceCenterState extends Equatable {
  const ServiceCenterState();

  @override
  List<Object?> get props => [];
}

final class ServiceCenterInitial extends ServiceCenterState {
  const ServiceCenterInitial();
}

final class ServiceCenterLoading extends ServiceCenterState {
  const ServiceCenterLoading();
}

final class ServiceCenterSuccess extends ServiceCenterState {
  final List<ServiceCenterEntity> serviceCenter;
  const ServiceCenterSuccess({required this.serviceCenter});

  @override
  List<Object?> get props => [serviceCenter];
}

final class ServiceCenterError extends ServiceCenterState {
  final String error;

  const ServiceCenterError({required this.error});

  @override
  List<Object?> get props => [error];
}
