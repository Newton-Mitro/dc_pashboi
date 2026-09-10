part of 'account_details_bloc.dart';

sealed class AccountDetailsState extends Equatable {
  const AccountDetailsState();

  @override
  List<Object?> get props => [];
}

final class AccountDetailsInitial extends AccountDetailsState {
  const AccountDetailsInitial();
}

final class AccountDetailsLoading extends AccountDetailsState {
  const AccountDetailsLoading();
}

final class AccountDetailsSuccess extends AccountDetailsState {
  final DepositAccountEntity account;

  const AccountDetailsSuccess(this.account);

  @override
  List<Object?> get props => [account];
}

final class AccountDetailsError extends AccountDetailsState {
  final String error;
  const AccountDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}
