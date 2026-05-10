import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/update_wooo_usecase.dart';

part 'update_wooo_request_event.dart';
part 'update_wooo_request_state.dart';

class UpdateWoooRequestBloc
    extends Bloc<UpdateWoooApplication, UpdateWoooRequestState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final UpdateWoooUseCase updateWoooUseCase;
  final AppLocalizationService appLocalizationService;

  UpdateWoooRequestBloc({
    required this.getAuthUserUseCase,
    required this.updateWoooUseCase,
    required this.appLocalizationService,
  }) : super(UpdateWoooRequestInitial()) {
    on<UpdateWoooApplication>(_updateWoooRequest);
  }

  Future<void> _updateWoooRequest(
    UpdateWoooApplication event,
    Emitter<UpdateWoooRequestState> emit,
  ) async {
    emit(const UpdateWoooRequestLoading());

    try {
      final userResult = await getAuthUserUseCase.call(NoParams());

      await userResult.fold(
        (failure) async {
          emit(UpdateWoooRequestError(failure.message));
        },
        (authData) async {
          final user = authData.user;
          final searchResult = await updateWoooUseCase(
            UpdateWoooProps(
              email: user.loginEmail,
              userId: user.userId,
              rolePermissionId: user.roleId,
              personId: user.personId,
              employeeCode: user.employeeCode,
              mobileNumber: user.regMobile,
              fromDate: event.fromDate,
              toDate: event.toDate,
              rejoiningDate: event.rejoiningDate,
              reason: event.reason,
              woooTypeCode: event.woooTypeCode,
              isHourly: event.isHourly,
              leaveApplicationId: event.leaveApplicationId,
            ),
          );

          searchResult.fold(
            (failure) {
              emit(UpdateWoooRequestError(failure.message));
            },
            (message) {
              emit(UpdateWoooRequestSuccess(message));
            },
          );
        },
      );
    } catch (e) {
      emit(UpdateWoooRequestError(e.toString()));
    }
  }
}
