part of 'my_app_bloc.dart';

abstract class AppStatusState extends Equatable {
  const AppStatusState();

  @override
  List<Object?> get props => [];
}

class AppStatusInitial extends AppStatusState {
  const AppStatusInitial();
}

class AppStatusLoading extends AppStatusState {
  const AppStatusLoading();
}

class NewVersionAvailable extends AppStatusState {
  final String message;
  const NewVersionAvailable(this.message);

  @override
  List<Object?> get props => [message];
}

class UnderMaintenance extends AppStatusState {
  final String message;
  const UnderMaintenance(this.message);

  @override
  List<Object?> get props => [message];
}

class AppIsHealthy extends AppStatusState {
  const AppIsHealthy();
}

class AppStatusError extends AppStatusState {
  final String message;

  const AppStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
