part of 'openable_account_bloc.dart';

sealed class OpenableAccountEvent extends Equatable {
  const OpenableAccountEvent();

  @override
  List<Object?> get props => [];
}

class FetchOpenableAccountsEvent extends OpenableAccountEvent {
  const FetchOpenableAccountsEvent();
}
