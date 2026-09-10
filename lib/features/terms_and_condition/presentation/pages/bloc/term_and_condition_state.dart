part of 'term_and_condition_bloc.dart';

sealed class TermAndConditionState extends Equatable {
  const TermAndConditionState();

  @override
  List<Object?> get props => [];
}

final class TermAndConditionInitial extends TermAndConditionState {
  const TermAndConditionInitial();
}

final class TermAndConditionLoading extends TermAndConditionState {
  const TermAndConditionLoading();
}

final class TermAndConditionLoaded extends TermAndConditionState {
  final String content;
  const TermAndConditionLoaded({required this.content});

  @override
  List<Object?> get props => [content];
}

final class TermAndConditionError extends TermAndConditionState {
  final String message;
  const TermAndConditionError({required this.message});

  @override
  List<Object?> get props => [message];
}
