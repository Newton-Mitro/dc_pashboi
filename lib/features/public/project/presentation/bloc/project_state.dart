part of 'project_bloc.dart';

sealed class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

final class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

final class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

final class ProjectSuccess extends ProjectState {
  final List<ProjectEntity> projects;
  const ProjectSuccess({required this.projects});

  @override
  List<Object?> get props => [projects];
}

final class ProjectError extends ProjectState {
  final String error;

  const ProjectError({required this.error});

  @override
  List<Object?> get props => [error];
}
