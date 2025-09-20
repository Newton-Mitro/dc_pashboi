part of 'term_and_condition_bloc.dart';

sealed class TermAndConditionEvent extends Equatable {
  const TermAndConditionEvent();

  @override
  List<Object> get props => [];
}

class FetchTermAndConditionEvent extends TermAndConditionEvent {
  final String contentName;

  const FetchTermAndConditionEvent({required this.contentName});
}
