part of 'get_wooo_data_bloc.dart';

sealed class GetWoooDataEvent extends Equatable {
  const GetWoooDataEvent();

  @override
  List<Object> get props => [];
}

class FetchWoooDataEvent extends GetWoooDataEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const FetchWoooDataEvent({required this.fromDate, required this.toDate});

  @override
  List<Object> get props => [fromDate, toDate];
}
