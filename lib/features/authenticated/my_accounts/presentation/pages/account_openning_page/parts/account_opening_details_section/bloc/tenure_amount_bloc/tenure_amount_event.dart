part of 'tenure_amount_bloc.dart';

sealed class TenureAmountEvent extends Equatable {
  const TenureAmountEvent();

  @override
  List<Object?> get props => [];
}

class FetchTenureAmountsEvent extends TenureAmountEvent {
  final String productCode;
  final String duration;

  const FetchTenureAmountsEvent({
    required this.productCode,
    required this.duration,
  });

  @override
  List<Object?> get props => [productCode, duration];
}
