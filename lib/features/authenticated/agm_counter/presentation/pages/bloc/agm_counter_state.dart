part of 'agm_counter_bloc.dart';

sealed class AgmCounterState extends Equatable {
  const AgmCounterState();

  @override
  List<Object?> get props => [];
}

final class AgmCounterInitial extends AgmCounterState {
  const AgmCounterInitial();
}

final class AgmCounterInfoLoading extends AgmCounterState {
  const AgmCounterInfoLoading();
}

final class AgmCounterInfoLoaded extends AgmCounterState {
  final AGMCounterEntity agmCounterInfo;
  const AgmCounterInfoLoaded(this.agmCounterInfo);

  @override
  List<Object?> get props => [agmCounterInfo];
}

final class AgmCounterInfoError extends AgmCounterState {
  final String message;
  const AgmCounterInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
