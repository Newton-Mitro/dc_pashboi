part of 'scheduled_deposits_bloc.dart';

sealed class ScheduledDepositsState extends Equatable {
  const ScheduledDepositsState();

  @override
  List<Object?> get props => [];
}

final class ScheduledDepositsInitial extends ScheduledDepositsState {
  const ScheduledDepositsInitial();
}

class ScheduledDepositsLoading extends ScheduledDepositsState {
  const ScheduledDepositsLoading();
}

class ScheduledDepositsLoaded extends ScheduledDepositsState {
  final List<DepositRequestEntity> depositRequests;

  const ScheduledDepositsLoaded({required this.depositRequests});

  @override
  List<Object?> get props => [depositRequests];
}

class ScheduledDepositsFailure extends ScheduledDepositsState {
  final String error;

  const ScheduledDepositsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
