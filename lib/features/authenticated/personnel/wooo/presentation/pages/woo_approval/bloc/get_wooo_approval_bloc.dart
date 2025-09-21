import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_approval_usecase.dart';

part 'get_wooo_approval_event.dart';
part 'get_wooo_approval_state.dart';

class GetWoooApprovalBloc
    extends Bloc<FetchWoooApprovalDataEvent, GetWoooApprovalState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final GetWoooApprovalUsecase getWoooApprovalUsecase;
  GetWoooApprovalBloc({
    required this.getAuthUserUseCase,
    required this.getWoooApprovalUsecase,
  }) : super(GetWoooApprovalInitial()) {
    on<FetchWoooApprovalDataEvent>(_onfatchWoooApproval);
  }

  Future<void> _onfatchWoooApproval(
    FetchWoooApprovalDataEvent event,
    Emitter<GetWoooApprovalState> emit,
  ) async {
    emit(GetWoooApprovalLoading());

    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(GetWoooApprovalError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final WoooHistoryResult = await getWoooApprovalUsecase(
          GetWoooApprovalProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
            fromDate: event.fromDate,
            toDate: event.toDate,
          ),
        );

        WoooHistoryResult.fold(
          (failure) {
            emit(GetWoooApprovalError(failure.message));
          },
          (WoooData) {
            emit(GetWoooApprovalSuccess(WoooData));
          },
        );
      },
    );
  }
}
