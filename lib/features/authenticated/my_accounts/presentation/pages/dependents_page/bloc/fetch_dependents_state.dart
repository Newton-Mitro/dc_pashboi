part of 'fetch_dependents_bloc.dart';

sealed class FetchDependentsState extends Equatable {
  const FetchDependentsState();

  @override
  List<Object?> get props => [];
}

final class FetchDependentsInitial extends FetchDependentsState {
  const FetchDependentsInitial();
}

final class FetchDependentsLoading extends FetchDependentsState {
  const FetchDependentsLoading();
}

final class FetchDependentsLoaded extends FetchDependentsState {
  final List<DepositAccountEntity> dependents;

  const FetchDependentsLoaded(this.dependents);

  @override
  List<Object?> get props => [dependents];
}

final class FetchDependentsSuccess extends FetchDependentsState {
  final String message;

  const FetchDependentsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class FetchDependentsError extends FetchDependentsState {
  final String message;

  const FetchDependentsError(this.message);

  @override
  List<Object?> get props => [message];
}
