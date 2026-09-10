part of 'my_account_bloc.dart';

sealed class MyAccountEvent extends Equatable {
  const MyAccountEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyAccountEvent extends MyAccountEvent {
  final int accountHolderPersonId;

  const FetchMyAccountEvent(this.accountHolderPersonId);

  @override
  List<Object?> get props => [accountHolderPersonId];
}
