part of 'wooo_type_bloc.dart';

sealed class WoooTypeEvent extends Equatable {
  const WoooTypeEvent();

  @override
  List<Object> get props => [];
}

class FetchWoooTypeEvent extends WoooTypeEvent {
  const FetchWoooTypeEvent();
}
