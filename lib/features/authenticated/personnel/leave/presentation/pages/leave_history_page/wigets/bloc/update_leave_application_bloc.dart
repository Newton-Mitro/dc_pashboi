import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/update_leave_application_request_usecase.dart';

part 'update_leave_application_event.dart';
part 'update_leave_application_state.dart';

class UpdateLeaveApplicationBloc
    extends Bloc<UpdateLeaveApplicationEvent, UpdateLeaveApplicationState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final UpdateLeaveApplicationRequestUseCase
  updateLeaveApplicationRequestUseCase;
  final AppLocalizationService appLocalizationService;

  UpdateLeaveApplicationBloc({
    required this.getAuthUserUseCase,
    required this.updateLeaveApplicationRequestUseCase,
    required this.appLocalizationService,
  }) : super(UpdateLeaveApplicationInitial()) {
    on<UpdateLeaveApplication>(_updateLeaveApplication);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<UpdateLeaveApplicationState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      emit(
        const UpdateLeaveApplicationError('Failed to load user information'),
      );
      return null;
    }, (success) => success.user);
  }

  Future<void> _updateLeaveApplication(
    UpdateLeaveApplication event,
    Emitter<UpdateLeaveApplicationState> emit,
  ) async {
    final errors = <String, String>{};
    emit(const UpdateLeaveApplicationLoading());
    try {
      final user = await _getAuthenticatedUser(emit);
      if (user == null) return;

      final result = await updateLeaveApplicationRequestUseCase(
        UpdateLeaveApplicationRequestProps(
          remarks: event.remarks,
          fallbackEmployeeCode:
              event.leaveTypeCode == "03"
                  ? user.employeeCode
                  : event.fallbackEmployeeCode,
          rejoiningDate:
              event.leaveTypeCode == "03"
                  ? event.fromDate
                  : event.rejoiningDate,
          toDate: event.toDate,
          fromDate: event.fromDate,
          leaveTypeCode: event.leaveTypeCode,
          leaveStageRemarks: event.leaveStageRemarks,
          formTime: event.fromDate,
          toTime: event.toDate,
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          leaveApplicationId: event.leaveApplicationId,
        ),
      );

      result.fold(
        (failure) => emit(UpdateLeaveApplicationError(failure.message)),
        (success) => emit(UpdateLeaveApplicationSuccess(success)),
      );
    } catch (e) {
      emit(UpdateLeaveApplicationError(e.toString()));
    }
  }
}
