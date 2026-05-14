part of 'advertisement_bloc.dart';

sealed class AdvertisementState extends Equatable {
  const AdvertisementState();

  @override
  List<Object> get props => [];
}

final class AdvertisementInitial extends AdvertisementState {}

final class AdvertisementLoading extends AdvertisementState {}

final class AdvertisementLoaded extends AdvertisementState {
  final List<AdvertisementEntity> advertisements;
  const AdvertisementLoaded({required this.advertisements});

  @override
  List<Object> get props => [advertisements];
}

final class AdvertisementError extends AdvertisementState {
  final String error;

  const AdvertisementError({required this.error});

  @override
  List<Object> get props => [error];
}
