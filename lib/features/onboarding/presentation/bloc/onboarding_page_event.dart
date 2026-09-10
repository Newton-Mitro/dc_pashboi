part of 'onboarding_page_bloc.dart';

abstract class OnboardingPageEvent extends Equatable {
  const OnboardingPageEvent();

  @override
  List<Object?> get props => [];
}

class SetOnboardingSeenEvent extends OnboardingPageEvent {
  final bool seen;

  const SetOnboardingSeenEvent({required this.seen});

  @override
  List<Object?> get props => [seen];
}

class GetOnboardingSeenEvent extends OnboardingPageEvent {
  const GetOnboardingSeenEvent();
}

class GetOnboardingInfosEvent extends OnboardingPageEvent {
  const GetOnboardingInfosEvent();
}
