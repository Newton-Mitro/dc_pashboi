part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent {
  const FetchProfileEvent();
}

class UpdateProfileImageEvent extends ProfileEvent {
  final String imageData;
  const UpdateProfileImageEvent({required this.imageData});

  @override
  List<Object?> get props => [imageData];
}
