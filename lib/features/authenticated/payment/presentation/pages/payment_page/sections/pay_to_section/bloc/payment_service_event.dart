part of 'payment_service_bloc.dart';

sealed class PaymentServiceEvent extends Equatable {
  const PaymentServiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchPaymentServicesEvent extends PaymentServiceEvent {
  const FetchPaymentServicesEvent();
}
