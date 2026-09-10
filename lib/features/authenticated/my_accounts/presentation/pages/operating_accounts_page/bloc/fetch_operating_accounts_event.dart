part of 'fetch_operating_accounts_bloc.dart';

class FetchOperatingAccountsEvent extends Equatable {
  final int dependentPersonId;
  const FetchOperatingAccountsEvent(this.dependentPersonId);

  @override
  List<Object?> get props => [dependentPersonId];
}
