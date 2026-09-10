part of 'my_account_bloc.dart';

sealed class MyAccountState extends Equatable {
  const MyAccountState();

  @override
  List<Object?> get props => [];
}

final class MyAccountInitial extends MyAccountState {
  const MyAccountInitial();
}

final class MyAccountLoading extends MyAccountState {
  const MyAccountLoading();
}

final class MyAccountSuccess extends MyAccountState {
  final List<DepositAccountEntity> myAccounts;

  const MyAccountSuccess(this.myAccounts);

  @override
  List<Object?> get props => [myAccounts];
}

final class MyAccountError extends MyAccountState {
  final String error;
  const MyAccountError(this.error);

  @override
  List<Object?> get props => [error];
}
