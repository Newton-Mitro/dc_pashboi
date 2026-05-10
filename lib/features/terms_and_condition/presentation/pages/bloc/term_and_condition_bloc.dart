import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/terms_and_condition/domain/usecases/fetch_term_and_condition_usecase.dart';

part 'term_and_condition_event.dart';
part 'term_and_condition_state.dart';

class TermAndConditionBloc
    extends Bloc<TermAndConditionEvent, TermAndConditionState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchTermAndConditionUseCase fetchTermAndConditionUseCase;
  final AppLocalizationService appLocalizationService;

  TermAndConditionBloc({
    required this.getAuthUserUseCase,
    required this.fetchTermAndConditionUseCase,
    required this.appLocalizationService,
  }) : super(TermAndConditionInitial()) {
    on<FetchTermAndConditionEvent>(_onFetchTermAndConditionEvent);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<TermAndConditionState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      emit(
        TermAndConditionError(
          message: appLocalizationService.t('failed_to_load_user_info'),
        ),
      );
      return null;
    }, (success) => success.user);
  }

  Future<void> _onFetchTermAndConditionEvent(
    FetchTermAndConditionEvent event,
    Emitter<TermAndConditionState> emit,
  ) async {
    emit(TermAndConditionLoading());

    final result = await fetchTermAndConditionUseCase.call(
      FetchTermAndConditionProps(contentName: event.contentName),
    );

    result.fold(
      (failure) => emit(TermAndConditionError(message: failure.message)),
      (content) => emit(TermAndConditionLoaded(content: content)),
    );
  }
}
