import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/fallback_request_usecase.dart';

part 'fallback_request_event.dart';
part 'fallback_request_state.dart';

class FallbackRequestBloc
    extends Bloc<FallbackRequestEvent, FallbackRequestState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FallbackRequestUseCase fallbackRequestUseCase;

  FallbackRequestBloc({
    required this.getAuthUserUseCase,
    required this.fallbackRequestUseCase,
  }) : super(FallbackRequestInitial()) {
    on<FetchFallbackRequests>(_fetchFallbackRequests);
  }

  Future<void> _fetchFallbackRequests(
    FetchFallbackRequests event,
    Emitter<FallbackRequestState> emit,
  ) async {
    emit(FallbackRequestLoading());
    try {
      final user = await getAuthUserUseCase(NoParams());
      final userEntity = user.fold((failure) {
        emit(FallbackRequestError('Failed to load user information'));
        return null;
      }, (success) => success.user);

      if (userEntity == null) return;

      final result = await fallbackRequestUseCase.call(
        FallbackRequestUseCaseProps(
          email: userEntity.loginEmail,
          userId: userEntity.userId,
          rolePermissionId: userEntity.roleId,
          personId: userEntity.personId,
          employeeCode: userEntity.employeeCode,
          mobileNumber: userEntity.regMobile,
        ),
      );

      result.fold(
        (failure) => emit(FallbackRequestError(failure.message)),
        (success) => emit(FallbackRequestSuccess(success)),
      );
    } catch (e) {
      emit(FallbackRequestError(e.toString()));
    }
  }
}
