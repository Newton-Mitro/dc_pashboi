part of 'fetch_operating_accounts_bloc.dart';

sealed class FetchOperatingAccountsState extends Equatable {
  const FetchOperatingAccountsState();

  @override
  List<Object?> get props => [];
}

final class FetchOperatingAccountsInitial extends FetchOperatingAccountsState {
  const FetchOperatingAccountsInitial();
}

final class FetchOperatingAccountsLoading extends FetchOperatingAccountsState {
  const FetchOperatingAccountsLoading();
}

final class FetchOperatingAccountsLoaded extends FetchOperatingAccountsState {
  final List<DepositAccountEntity> operatingAccounts;

  const FetchOperatingAccountsLoaded(this.operatingAccounts);

  @override
  List<Object?> get props => [operatingAccounts];
}

final class FetchOperatingAccountsSuccess extends FetchOperatingAccountsState {
  final String message;

  const FetchOperatingAccountsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class FetchOperatingAccountsError extends FetchOperatingAccountsState {
  final String message;

  const FetchOperatingAccountsError(this.message);

  @override
  List<Object?> get props => [message];
}
