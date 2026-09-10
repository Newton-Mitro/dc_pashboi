part of 'service_center_bloc.dart';

sealed class ServiceCenterEvent extends Equatable {
  const ServiceCenterEvent();

  @override
  List<Object?> get props => [];
}

class FetchServiceCenterEvent extends ServiceCenterEvent {
  const FetchServiceCenterEvent();
}
