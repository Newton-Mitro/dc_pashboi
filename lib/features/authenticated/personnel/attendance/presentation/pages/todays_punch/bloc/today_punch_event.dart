part of 'today_punch_bloc.dart';

sealed class TodayPunchEvent extends Equatable {
  const TodayPunchEvent();

  @override
  List<Object> get props => [];
}

class TodayPunchHistory extends TodayPunchEvent {
  final String fromDate;
  final String toDate;

  const TodayPunchHistory({required this.fromDate, required this.toDate});

  @override
  List<Object> get props => [fromDate, toDate];
}
