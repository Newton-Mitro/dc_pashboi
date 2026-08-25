import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_application_usecase.dart';

part 'leave_application_event.dart';
part 'leave_application_state.dart';

class LeaveApplicationBloc
    extends Bloc<LeaveApplicationEvent, LeaveApplicationState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitLeaveApplicationUseCase submitLeaveApplicationUseCase;
  final AppLocalizationService appLocalizationService;

  LeaveApplicationBloc({
    required this.getAuthUserUseCase,
    required this.submitLeaveApplicationUseCase,
    required this.appLocalizationService,
  }) : super(LeaveApplicationState()) {
    on<LeaveApplicationUpdateField>(_onUpdateField);
    on<LeaveApplicationSubmitEvent>(_onSubmit);
  }

  void _onUpdateField(
    LeaveApplicationUpdateField event,
    Emitter<LeaveApplicationState> emit,
  ) {
    final updatedData = Map<String, dynamic>.from(state.leaveApplicationData)
      ..addAll(event.data);
    var newState = state.copyWith(leaveApplicationData: updatedData);
    emit(newState);
  }

  void _onSubmit(
    LeaveApplicationSubmitEvent event,
    Emitter<LeaveApplicationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: '', successMessage: ''));

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(
          state.copyWith(
            error: appLocalizationService.t('failed_to_load_user_info'),
            isLoading: false,
          ),
        );
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;
      final data = state.leaveApplicationData;
      final remarks = data['description'];
      final leaveTypeCode = data['selectedLeaveType'];
      final fallbackEmployeeCode = data['fallbackEmployeeCode'];
      final fromDate = data['startDate'];
      final toDate = data['endDate'];
      final rejoiningDate = data['rejoiningDate'];
      final leaveStageRemarks = data['leaveStageRemarks'];

      final testData = SubmitLeaveApplicationProps(
        remarks: remarks ?? '',
        rejoiningDate: rejoiningDate == null ? '' : fromDate.toString(),
        fallbackEmployeeCode: fallbackEmployeeCode ?? user.employeeCode,
        toDate: toDate == null ? '' : toDate.toString(),
        fromDate: fromDate == null ? '' : fromDate.toString(),
        leaveTypeCode: leaveTypeCode,
        leaveStageRemarks: leaveStageRemarks ?? '',
        formTime: fromDate == null ? '' : fromDate.toString(),
        toTime: toDate == null ? '' : toDate.toString(),
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
      );

      final result = await submitLeaveApplicationUseCase.call(testData);

      result.fold(
        (failure) =>
            emit(state.copyWith(error: failure.message, isLoading: false)),
        (message) =>
            emit(state.copyWith(successMessage: message, isLoading: false)),
      );
    } catch (e) {
      print('Leave Application Submit Error: $e');

      emit(
        state.copyWith(
          error: appLocalizationService.t('failed_to_submit_leave_application'),
          isLoading: false,
        ),
      );
    }
  }
}
