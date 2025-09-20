import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  TermAndConditionBloc({
    required this.getAuthUserUseCase,
    required this.fetchTermAndConditionUseCase,
  }) : super(TermAndConditionInitial()) {
    on<FetchTermAndConditionEvent>(_onFetchTermAndConditionEvent);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<TermAndConditionState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      emit(TermAndConditionError(message: 'Failed to load user information'));
      return null;
    }, (success) => success.user);
  }

  Future<void> _onFetchTermAndConditionEvent(
    FetchTermAndConditionEvent event,
    Emitter<TermAndConditionState> emit,
  ) async {
    emit(TermAndConditionLoading());

    final user = await _getAuthenticatedUser(emit);
    if (user == null) return;

    final result = await fetchTermAndConditionUseCase.call(
      FetchTermAndConditionProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
        contentName: event.contentName,
      ),
    );

    result.fold(
      (failure) => emit(TermAndConditionError(message: failure.message)),
      (content) => emit(TermAndConditionLoaded(content: content)),
    );
  }
}
