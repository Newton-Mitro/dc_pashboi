import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/leave_type_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_usecase.dart';

part 'leave_type_event.dart';
part 'leave_type_state.dart';

class LeaveTypeBloc extends Bloc<LeaveTypeEvent, LeaveTypeState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final LeaveTypeUseCase leaveTypeUseCase;
  LeaveTypeBloc({
    required this.getAuthUserUseCase,
    required this.leaveTypeUseCase,
  }) : super(LeaveTypeInitial()) {
    on<FetchLeaveTypeEvent>(_onFetchLeaveType);
  }

  Future<void> _onFetchLeaveType(
    FetchLeaveTypeEvent event,
    Emitter<LeaveTypeState> emit,
  ) async {
    emit(const LeaveTypeLoading());
    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(LeaveTypeError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final employeeResult = await leaveTypeUseCase(
          LeaveTypeProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
          ),
        );

        employeeResult.fold(
          (failure) {
            emit(LeaveTypeError(failure.message));
          },
          (employee) {
            emit(LeaveTypeSuccess(employee));
          },
        );
      },
    );
  }
}
