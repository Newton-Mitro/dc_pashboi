import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_approval_usecase.dart';

part 'leave_approval_event.dart';
part 'leave_approval_state.dart';

class LeaveApprovalBloc extends Bloc<LeaveApprovalEvent, LeaveApprovalState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final LeaveApprovalUseCase getLeaveApprovalUseCase;

  LeaveApprovalBloc({
    required this.getAuthUserUseCase,
    required this.getLeaveApprovalUseCase,
  }) : super(LeaveApprovalInitial()) {
    on<FetchLeaveApprovals>(_fetchLeaveApprovals);
  }

  Future<void> _fetchLeaveApprovals(
    FetchLeaveApprovals event,
    Emitter<LeaveApprovalState> emit,
  ) async {
    emit(LeaveApprovalLoading());
    try {
      final user = await getAuthUserUseCase(NoParams());
      final userEntity = user.fold((failure) {
        emit(LeaveApprovalError('Failed to load user information'));
        return null;
      }, (success) => success.user);

      if (userEntity == null) return;

      final result = await getLeaveApprovalUseCase.call(
        LeaveApprovalProps(
          email: userEntity.loginEmail,
          userId: userEntity.userId,
          rolePermissionId: userEntity.roleId,
          personId: userEntity.personId,
          employeeCode: userEntity.employeeCode,
          mobileNumber: userEntity.regMobile,
          formDate: event.fromDate,
          toDate: event.toDate,
        ),
      );

      result.fold(
        (failure) => emit(LeaveApprovalError(failure.message)),
        (success) => emit(LeaveApprovalSuccess(success)),
      );
    } catch (e) {
      emit(LeaveApprovalError(e.toString()));
    }
  }
}
