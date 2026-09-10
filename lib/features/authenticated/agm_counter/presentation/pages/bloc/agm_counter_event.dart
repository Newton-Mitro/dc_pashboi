part of 'agm_counter_bloc.dart';

sealed class AgmCounterEvent extends Equatable {
  const AgmCounterEvent();

  @override
  List<Object?> get props => [];
}

class FetchAgmCounterInfoEvent extends AgmCounterEvent {
  final String accountNo;

  const FetchAgmCounterInfoEvent({required this.accountNo});

  @override
  List<Object?> get props => [accountNo];
}
