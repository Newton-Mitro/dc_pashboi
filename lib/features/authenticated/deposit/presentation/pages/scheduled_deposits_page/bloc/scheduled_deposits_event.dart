part of 'scheduled_deposits_bloc.dart';

sealed class ScheduledDepositsEvent extends Equatable {
  const ScheduledDepositsEvent();

  @override
  List<Object?> get props => [];
}

class FetchScheduledDeposits extends ScheduledDepositsEvent {
  const FetchScheduledDeposits();
}
