import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_application_entites.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_history_request_usecase.dart';

part 'leave_history_event.dart';
part 'leave_history_state.dart';

class LeaveHistoryBloc extends Bloc<LeaveHistoryEvent, LeaveHistoryState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final LeaveHistoryRequestUseCase leaveHistoryRequestUseCase;
  final AppLocalizationService appLocalizationService;

  LeaveHistoryBloc({
    required this.getAuthUserUseCase,
    required this.leaveHistoryRequestUseCase,
    required this.appLocalizationService,
  }) : super(LeaveHistoryInitial()) {
    on<FetchLeaveHistory>(_fetchLeaveHistory);
  }

  Future<void> _fetchLeaveHistory(
    FetchLeaveHistory event,
    Emitter<LeaveHistoryState> emit,
  ) async {
    emit(LeaveHistoryLoading());
    try {
      final user = await getAuthUserUseCase(NoParams());
      final userEntity = user.fold((failure) {
        emit(
          LeaveHistoryError(
            appLocalizationService.t('failed_to_load_user_info'),
          ),
        );
        return null;
      }, (success) => success.user);

      if (userEntity == null) return;

      final result = await leaveHistoryRequestUseCase.call(
        LeaveHistoryRequestProps(
          email: userEntity.loginEmail,
          userId: userEntity.userId,
          rolePermissionId: userEntity.roleId,
          personId: userEntity.personId,
          employeeCode: userEntity.employeeCode,
          mobileNumber: userEntity.regMobile,
          fromDate: event.fromDate,
          toDate: event.toDate,
        ),
      );

      result.fold(
        (failure) => emit(LeaveHistoryError(failure.message)),
        (success) => emit(LeaveHistorySuccess(success)),
      );
    } catch (e) {
      emit(LeaveHistoryError(e.toString()));
    }
  }
}
