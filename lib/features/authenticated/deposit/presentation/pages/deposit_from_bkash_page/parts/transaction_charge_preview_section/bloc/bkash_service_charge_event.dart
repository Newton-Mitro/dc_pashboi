part of 'bkash_service_charge_bloc.dart';

sealed class BkashServiceChargeEvent extends Equatable {
  const BkashServiceChargeEvent();

  @override
  List<Object?> get props => [];
}

class FetchBkashServiceChargeEvent extends BkashServiceChargeEvent {
  final double totalAmount;

  const FetchBkashServiceChargeEvent({required this.totalAmount});

  @override
  List<Object?> get props => [totalAmount];
}
