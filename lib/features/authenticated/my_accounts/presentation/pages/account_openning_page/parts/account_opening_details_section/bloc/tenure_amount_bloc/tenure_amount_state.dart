part of 'tenure_amount_bloc.dart';

sealed class TenureAmountState extends Equatable {
  const TenureAmountState();

  @override
  List<Object?> get props => [];
}

final class TenureAmountInitial extends TenureAmountState {
  const TenureAmountInitial();
}

final class TenureAmountLoading extends TenureAmountState {
  const TenureAmountLoading();
}

final class TenureAmountSuccess extends TenureAmountState {
  final List<TenureAmountEntity> tenureAmounts;

  const TenureAmountSuccess(this.tenureAmounts);

  @override
  List<Object?> get props => [tenureAmounts];
}

final class TenureAmountError extends TenureAmountState {
  final String error;
  const TenureAmountError(this.error);

  @override
  List<Object?> get props => [error];
}
