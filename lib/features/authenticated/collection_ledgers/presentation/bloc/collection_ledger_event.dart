part of 'collection_ledger_bloc.dart';

sealed class CollectionLedgerEvent extends Equatable {
  const CollectionLedgerEvent();

  @override
  List<Object?> get props => [];
}

final class FetchCollectionLedgersEvent extends CollectionLedgerEvent {
  final String searchText;
  final String moduleCode;

  const FetchCollectionLedgersEvent({
    required this.searchText,
    required this.moduleCode,
  });

  @override
  List<Object?> get props => [searchText, moduleCode];
}
