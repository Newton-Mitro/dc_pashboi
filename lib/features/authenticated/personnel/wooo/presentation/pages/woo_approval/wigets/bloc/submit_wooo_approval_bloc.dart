import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_approval_submit_usecase.dart';

part 'submit_wooo_approval_event.dart';
part 'submit_wooo_approval_state.dart';

class SubmitWoooApprovalBloc
    extends Bloc<SubmitWoooApplicationEvent, SubmitWoooApprovalState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final WoooApprovalSubmitUseCase woooApprovalSubmitUseCase;
  final AppLocalizationService appLocalizationService;

  SubmitWoooApprovalBloc({
    required this.getAuthUserUseCase,
    required this.woooApprovalSubmitUseCase,
    required this.appLocalizationService,
  }) : super(SubmitWoooApprovalInitial()) {
    on<SubmitWoooApplicationEvent>(_submitWoooApprovalRequest);
  }
  Future<void> _submitWoooApprovalRequest(
    SubmitWoooApplicationEvent event,
    Emitter<SubmitWoooApprovalState> emit,
  ) async {
    emit(const SubmitWoooApprovalLoading());

    try {
      final userResult = await getAuthUserUseCase.call(NoParams());

      await userResult.fold(
        (failure) async {
          emit(SubmitWoooApprovalError(failure.message));
        },
        (authData) async {
          final user = authData.user;
          final searchResult = await woooApprovalSubmitUseCase(
            WoooApprovalSubmitUseCaseProps(
              email: user.loginEmail,
              userId: user.userId,
              rolePermissionId: user.roleId,
              personId: user.personId,
              employeeCode: user.employeeCode,
              mobileNumber: user.regMobile,
              employeeWoooId: event.employeeWoooId,
              status: event.status,
            ),
          );

          searchResult.fold(
            (failure) {
              emit(SubmitWoooApprovalError(failure.message));
            },
            (message) {
              emit(SubmitWoooApprovalSuccess(message));
            },
          );
        },
      );
    } catch (e) {
      emit(SubmitWoooApprovalError(e.toString()));
    }
  }
}
