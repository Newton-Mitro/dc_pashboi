part of 'onboarding_page_bloc.dart';

abstract class OnboardingPageState extends Equatable {
  const OnboardingPageState();

  @override
  List<Object?> get props => [];
}

class OnboardingPageInitial extends OnboardingPageState {
  const OnboardingPageInitial();
}

class OnboardingLoading extends OnboardingPageState {
  const OnboardingLoading();
}

class OnboardingSeenSetSuccess extends OnboardingPageState {
  const OnboardingSeenSetSuccess();
}

class OnboardingSeenLoaded extends OnboardingPageState {
  final bool seen;

  const OnboardingSeenLoaded({required this.seen});

  @override
  List<Object?> get props => [seen];
}

class OnboardingInfosLoaded extends OnboardingPageState {
  final List<String> infos; // Adjust based on actual info model

  const OnboardingInfosLoaded({required this.infos});

  @override
  List<Object?> get props => [infos];
}

class OnboardingError extends OnboardingPageState {
  final String message;

  const OnboardingError({required this.message});

  @override
  List<Object?> get props => [message];
}
