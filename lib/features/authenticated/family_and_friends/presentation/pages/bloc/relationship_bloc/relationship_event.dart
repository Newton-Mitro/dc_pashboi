part of 'relationship_bloc.dart';

sealed class RelationshipEvent extends Equatable {
  const RelationshipEvent();

  @override
  List<Object?> get props => [];
}

final class FetchRelationshipsEvent extends RelationshipEvent {
  final String gender;

  const FetchRelationshipsEvent({required this.gender});

  @override
  List<Object?> get props => [gender];
}
