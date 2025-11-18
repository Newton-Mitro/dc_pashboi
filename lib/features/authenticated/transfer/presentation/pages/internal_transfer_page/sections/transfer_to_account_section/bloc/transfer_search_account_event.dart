part of 'transfer_search_account_bloc.dart';

sealed class TransferSearchAccountEvent extends Equatable {
  const TransferSearchAccountEvent();

  @override
  List<Object> get props => [];
}

final class FetchTransferSearchAccountEvent extends TransferSearchAccountEvent {
  final String searchText;
  final String moduleCode;

  const FetchTransferSearchAccountEvent({
    required this.searchText,
    required this.moduleCode,
  });

  @override
  List<Object> get props => [searchText, moduleCode];
}
