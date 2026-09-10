part of 'collection_ledger_bloc.dart';

sealed class CollectionLedgerState extends Equatable {
  const CollectionLedgerState();

  @override
  List<Object?> get props => [];
}

final class CollectionLedgerInitial extends CollectionLedgerState {
  const CollectionLedgerInitial();
}

final class CollectionLedgerLoading extends CollectionLedgerState {
  const CollectionLedgerLoading();
}

final class CollectionLedgerLoaded extends CollectionLedgerState {
  final CollectionAggregate collectionAggregate;

  const CollectionLedgerLoaded(this.collectionAggregate);

  @override
  List<Object?> get props => [collectionAggregate];
}

final class CollectionLedgerError extends CollectionLedgerState {
  final String message;

  const CollectionLedgerError(this.message);

  @override
  List<Object?> get props => [message];
}

final class CollectionLedgerValidationError extends CollectionLedgerState {
  final Map<String, String> errors;

  const CollectionLedgerValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}
