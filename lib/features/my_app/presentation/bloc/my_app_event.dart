part of 'my_app_bloc.dart';

abstract class AppStatusEvent extends Equatable {
  const AppStatusEvent();

  @override
  List<Object?> get props => [];
}

class FetchAppStatusEvent extends AppStatusEvent {
  const FetchAppStatusEvent();
}
