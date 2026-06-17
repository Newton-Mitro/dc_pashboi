part of 'advertisement_bloc.dart';

sealed class AdvertisementEvent extends Equatable {
  const AdvertisementEvent();

  @override
  List<Object> get props => [];
}

class FetchAdvertisementEvent extends AdvertisementEvent {}
