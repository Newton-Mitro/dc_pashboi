part of 'transfer_search_account_bloc.dart';

sealed class TransferSearchAccountState extends Equatable {
  const TransferSearchAccountState();
  
  @override
  List<Object> get props => [];
}

final class TransferSearchAccountInitial extends TransferSearchAccountState {}
