part of 'account_details_bloc.dart';

sealed class AccountDetailsEvent extends Equatable {
  const AccountDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAccountDetailsEvent extends AccountDetailsEvent {
  final String accountNumber;
  const FetchAccountDetailsEvent({required this.accountNumber});

  @override
  List<Object?> get props => [accountNumber];
}
