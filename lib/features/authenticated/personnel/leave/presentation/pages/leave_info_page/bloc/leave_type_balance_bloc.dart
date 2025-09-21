import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/data/model/get_leave_type_blance_dto.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/leave_type_blance_usecase.dart';
part 'leave_type_balance_event.dart';
part 'leave_type_balance_state.dart';

class LeaveTypeBalanceBloc
    extends Bloc<LeaveTypeBalanceEvent, LeaveTypeBalanceState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final LeaveTypeBalanceUseCase leaveTypeBalanceUseCase;

  LeaveTypeBalanceBloc({
    required this.getAuthUserUseCase,
    required this.leaveTypeBalanceUseCase,
  }) : super(LeaveTypeBalanceInitial()) {
    on<FetchLeaveTypeBalanceEvent>(_onFetchLeaveTypeBalance);
  }

  Future<void> _onFetchLeaveTypeBalance(
    FetchLeaveTypeBalanceEvent event,
    Emitter<LeaveTypeBalanceState> emit,
  ) async {
    emit(const LeaveTypeBalanceLoading());
    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(LeaveTypeBalanceError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final leaveTypeBalanceResult = await leaveTypeBalanceUseCase.call(
          LeaveTypeBalanceProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
            leaveTypeCode: event.leaveTypeCode,
          ),
        );

        leaveTypeBalanceResult.fold(
          (failure) {
            emit(LeaveTypeBalanceError(failure.message));
          },
          (leaveTypeBalance) {
            emit(LeaveTypeBalanceSuccess(leaveTypeBalance));
          },
        );
      },
    );
  }
}
