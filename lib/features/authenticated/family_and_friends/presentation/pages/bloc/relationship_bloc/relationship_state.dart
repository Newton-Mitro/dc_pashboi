part of 'relationship_bloc.dart';

sealed class RelationshipState extends Equatable {
  const RelationshipState();

  @override
  List<Object?> get props => [];
}

final class RelationshipInitial extends RelationshipState {
  const RelationshipInitial();
}

final class RelationshipLoading extends RelationshipState {
  const RelationshipLoading();
}

final class RelationshipLoaded extends RelationshipState {
  final List<RelationshipEntity> relationships;

  const RelationshipLoaded(this.relationships);

  @override
  List<Object?> get props => [relationships];
}

final class RelationshipError extends RelationshipState {
  final String message;

  const RelationshipError(this.message);

  @override
  List<Object?> get props => [message];
}
