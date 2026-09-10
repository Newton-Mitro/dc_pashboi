part of 'payment_service_bloc.dart';

sealed class PaymentServiceState extends Equatable {
  const PaymentServiceState();

  @override
  List<Object?> get props => [];
}

final class PaymentServiceInitial extends PaymentServiceState {
  const PaymentServiceInitial();
}

final class PaymentServiceLoading extends PaymentServiceState {
  const PaymentServiceLoading();
}

final class PaymentServiceLoaded extends PaymentServiceState {
  final List<ServiceEntity> services;
  const PaymentServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

final class PaymentServiceError extends PaymentServiceState {
  final String message;
  const PaymentServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
