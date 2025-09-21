import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/accepted_fallback_request_usecase.dart';

part 'accepted_fallback_request_event.dart';
part 'accepted_fallback_request_state.dart';

class AcceptedFallbackRequestBloc
    extends Bloc<AcceptedFallbackRequestEvent, AcceptedFallbackRequestState> {
  final AcceptedFallbackUseCase acceptedFallbackRequestUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;

  AcceptedFallbackRequestBloc({
    required this.acceptedFallbackRequestUseCase,
    required this.getAuthUserUseCase,
  }) : super(AcceptedFallbackRequestInitial()) {
    on<AcceptedFallbackRequestSubmitted>(_submitAcceptedFallbackRequest);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<AcceptedFallbackRequestState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      emit(
        const AcceptedFallbackRequestError('Failed to load user information'),
      );
      return null;
    }, (success) => success.user);
  }

  Future<void> _submitAcceptedFallbackRequest(
    AcceptedFallbackRequestSubmitted event,
    Emitter<AcceptedFallbackRequestState> emit,
  ) async {
    emit(const AcceptedFallbackRequestLoading());

    try {
      final user = await _getAuthenticatedUser(emit);
      if (user == null) return;

      final result = await acceptedFallbackRequestUseCase.call(
        AcceptedFallbackRequestParams(
          remarks: event.remarks,
          leaveApplicationId: event.leaveApplicationId,
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
        ),
      );

      result.fold(
        (failure) => emit(AcceptedFallbackRequestError(failure.message)),
        (success) => emit(AcceptedFallbackRequestSuccess(success)),
      );
    } catch (e) {
      emit(AcceptedFallbackRequestError(e.toString()));
    }
  }
}
