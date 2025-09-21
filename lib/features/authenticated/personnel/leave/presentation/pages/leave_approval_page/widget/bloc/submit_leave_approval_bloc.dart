import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_approvel_usecase.dart';

part 'submit_leave_approval_event.dart';
part 'submit_leave_approval_state.dart';

class SubmitLeaveApprovalBloc
    extends Bloc<SubmitLeaveApprovalEvent, SubmitLeaveApprovalState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitLeaveApprovalUseCase submitLeaveApprovalUseCase;

  SubmitLeaveApprovalBloc({
    required this.getAuthUserUseCase,
    required this.submitLeaveApprovalUseCase,
  }) : super(SubmitLeaveApprovalInitial()) {
    on<SubmitLeaveApprovals>(_submitLeaveApproval);
  }

  Future<void> _submitLeaveApproval(
    SubmitLeaveApprovals event,
    Emitter<SubmitLeaveApprovalState> emit,
  ) async {
    emit(SubmitLeaveApprovalLoading());
    try {
      final user = await getAuthUserUseCase(NoParams());
      final userEntity = user.fold((failure) {
        emit(SubmitLeaveApprovalError('Failed to load user information'));
        return null;
      }, (success) => success.user);

      if (userEntity == null) return;

      final result = await submitLeaveApprovalUseCase.call(
        SubmitLeaveApprovalProps(
          email: userEntity.loginEmail,
          userId: userEntity.userId,
          rolePermissionId: userEntity.roleId,
          personId: userEntity.personId,
          employeeCode: userEntity.employeeCode,
          mobileNumber: userEntity.regMobile,
          leaveStageRemarks: event.leaveStageRemarks,
          leaveApplicationId: event.leaveApplicationId,
        ),
      );

      result.fold(
        (failure) => emit(SubmitLeaveApprovalError(failure.message)),
        (success) => emit(SubmitLeaveApprovalSuccess(success)),
      );
    } catch (e) {
      emit(SubmitLeaveApprovalError(e.toString()));
    }
  }
}
