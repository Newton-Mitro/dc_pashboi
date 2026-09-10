part of 'tenure_bloc.dart';

sealed class TenureEvent extends Equatable {
  const TenureEvent();

  @override
  List<Object?> get props => [];
}

class FetchTenuresEvent extends TenureEvent {
  final String productCode;

  const FetchTenuresEvent(this.productCode);

  @override
  List<Object?> get props => [productCode];
}
