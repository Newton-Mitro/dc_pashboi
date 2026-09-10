part of 'project_bloc.dart';

sealed class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class FetchProjectEvent extends ProjectEvent {
  const FetchProjectEvent();
}
