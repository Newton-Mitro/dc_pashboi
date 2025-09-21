import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/get_attendance_entities.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/get_attandance_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/presentation/pages/attendance_calender/bloc/attendance_calender_event.dart';
part 'attendance_calender_state.dart';

class AttendanceCalenderBloc
    extends Bloc<AttendanceCalenderHistory, AttendanceCalenderState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final AttendanceUseCase attendanceUseCase;

  AttendanceCalenderBloc({
    required this.getAuthUserUseCase,
    required this.attendanceUseCase,
  }) : super(AttendanceCalenderInitial()) {
    on<AttendanceCalenderHistory>(_fetchAttendanceHistory);
  }

  Future<void> _fetchAttendanceHistory(
    AttendanceCalenderHistory event,
    Emitter<AttendanceCalenderState> emit,
  ) async {
    emit(AttendanceCalenderLoading());
    try {
      final userResult = await getAuthUserUseCase(NoParams());

      final userEntity = userResult.fold((failure) {
        emit(AttendanceCalenderError('Failed to load user information'));
        return null;
      }, (success) => success.user);

      if (userEntity == null) return;

      final result = await attendanceUseCase.call(
        AttendanceProps(
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
        (failure) => emit(AttendanceCalenderError(failure.message)),
        (success) => emit(AttendanceCalenderSuccess(success)),
      );
    } catch (e) {
      emit(AttendanceCalenderError(e.toString()));
    }
  }
}
