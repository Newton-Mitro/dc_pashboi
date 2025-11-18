part of 'transfer_search_account_bloc.dart';

sealed class TransferSearchAccountState extends Equatable {
  const TransferSearchAccountState();

  @override
  List<Object> get props => [];
}

final class TransferSearchAccountInitial extends TransferSearchAccountState {}

final class TransferSearchAccountLoading extends TransferSearchAccountState {}

final class TransferSearchAccountLoaded extends TransferSearchAccountState {
  final String accountHolderName;

  const TransferSearchAccountLoaded(this.accountHolderName);

  @override
  List<Object> get props => [accountHolderName];
}

final class TransferSearchAccountError extends TransferSearchAccountState {
  final String message;

  const TransferSearchAccountError(this.message);

  @override
  List<Object> get props => [message];
}

final class TransferSearchAccountValidationError
    extends TransferSearchAccountState {
  final Map<String, String> errors;

  const TransferSearchAccountValidationError(this.errors);

  @override
  List<Object> get props => [errors];
}
