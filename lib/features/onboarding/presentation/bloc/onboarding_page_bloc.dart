import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';
import 'package:pashboi/features/onboarding/domain/usecases/set_onboarding_seen_usecase.dart';

part 'onboarding_page_event.dart';
part 'onboarding_page_state.dart';

class OnboardingPageBloc
    extends Bloc<OnboardingPageEvent, OnboardingPageState> {
  final SetOnboardingSeenUseCase setOnBoardingSeenUseCase;
  final GetOnboardingSeenUseCase getOnBoardingSeenUseCase;
  OnboardingPageBloc({
    required this.setOnBoardingSeenUseCase,
    required this.getOnBoardingSeenUseCase,
  }) : super(OnboardingPageInitial()) {
    on<SetOnboardingSeenEvent>(_setOnboardingSeen);
    on<GetOnboardingSeenEvent>(_getOnBoardingSeen);
  }

  Future<void> _setOnboardingSeen(
    SetOnboardingSeenEvent event,
    Emitter<OnboardingPageState> emit,
  ) async {
    emit(OnboardingLoading());
    final params = SetOnboardingSeenParams(seen: event.seen);
    final result = await setOnBoardingSeenUseCase.call(params);
    result.fold(
      (failure) {
        if (failure is CacheFailure) {
          emit(OnboardingError(message: failure.message));
        } else {
          emit(OnboardingError(message: failure.message));
        }
      },
      (seen) {
        emit(OnboardingSeenSetSuccess());
      },
    );
  }

  Future<void> _getOnBoardingSeen(
    GetOnboardingSeenEvent event,
    Emitter<OnboardingPageState> emit,
  ) async {
    emit(OnboardingLoading());
    final result = await getOnBoardingSeenUseCase.call(NoParams());
    result.fold(
      (failure) {
        if (failure is CacheFailure) {
          emit(OnboardingError(message: failure.message));
        } else {
          emit(OnboardingError(message: failure.message));
        }
      },
      (seen) {
        emit(OnboardingSeenLoaded(seen: seen));
      },
    );
  }
}
