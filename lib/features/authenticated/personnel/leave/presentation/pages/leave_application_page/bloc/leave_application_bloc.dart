import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/submit_leave_application_usecase.dart';

part 'leave_application_event.dart';
part 'leave_application_state.dart';

class LeaveApplicationBloc
    extends Bloc<LeaveApplicationEvent, LeaveApplicationState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitLeaveApplicationUseCase submitLeaveApplicationUseCase;

  LeaveApplicationBloc({
    required this.getAuthUserUseCase,
    required this.submitLeaveApplicationUseCase,
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

    print(newState);

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
        emit(state.copyWith(error: 'User not found', isLoading: false));
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

      final result = await submitLeaveApplicationUseCase.call(
        SubmitLeaveApplicationProps(
          remarks: remarks ?? '',
          fallbackEmployeeCode:
              leaveTypeCode == "03" ? user.employeeCode : fallbackEmployeeCode,
          rejoiningDate: rejoiningDate.toString(),
          toDate: toDate.toString(),
          fromDate: fromDate.toString(),
          leaveTypeCode: leaveTypeCode,
          leaveStageRemarks: leaveStageRemarks ?? '',
          formTime: fromDate.toString(),
          toTime: toDate.toString(),
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
        ),
      );

      result.fold(
        (failure) =>
            emit(state.copyWith(error: failure.message, isLoading: false)),
        (message) =>
            emit(state.copyWith(successMessage: message, isLoading: false)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to submit leave application',
          isLoading: false,
        ),
      );
    }
  }
}
