part of 'today_punch_bloc.dart';

sealed class TodayPunchState extends Equatable {
  const TodayPunchState();

  @override
  List<Object> get props => [];
}

final class TodayPunchInitial extends TodayPunchState {
  const TodayPunchInitial();
}

final class TodayPunchLoading extends TodayPunchState {
  const TodayPunchLoading();
}

final class TodayPunchSuccess extends TodayPunchState {
  final List<TodayPunchEntity> todayPunchEntities;

  const TodayPunchSuccess(this.todayPunchEntities);

  @override
  List<Object> get props => [todayPunchEntities];
}

final class TodayPunchError extends TodayPunchState {
  final String message;

  const TodayPunchError(this.message);

  @override
  List<Object> get props => [message];
}
