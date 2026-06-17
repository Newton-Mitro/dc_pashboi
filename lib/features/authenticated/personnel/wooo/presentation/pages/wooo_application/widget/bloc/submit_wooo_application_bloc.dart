import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/submit_wooo_application_usecase.dart';

part 'submit_wooo_application_event.dart';
part 'submit_wooo_application_state.dart';

class SubmitWoooApplicationBloc
    extends Bloc<SubmitWoooApplicationEvent, SubmitWoooApplicationState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final SubmitWoooApplicationUseCase submitWoooApplicationUseCase;
  final AppLocalizationService appLocalizationService;

  SubmitWoooApplicationBloc({
    required this.getAuthUserUseCase,
    required this.submitWoooApplicationUseCase,
    required this.appLocalizationService,
  }) : super(SubmitWoooApplicationInitial()) {
    on<SubmitWoooApplication>(_submitWooApplication);
  }

  Future<void> _submitWooApplication(
    SubmitWoooApplication event,
    Emitter<SubmitWoooApplicationState> emit,
  ) async {
    emit(const SubmitWoooApplicationLoading());

    try {
      final userResult = await getAuthUserUseCase.call(NoParams());

      await userResult.fold(
        (failure) async {
          emit(SubmitWoooApplicationError(failure.message));
        },
        (authData) async {
          final user = authData.user;
          final searchResult = await submitWoooApplicationUseCase(
            SubmitWoooApplicationPropsProps(
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
            ),
          );

          searchResult.fold(
            (failure) {
              emit(SubmitWoooApplicationError(failure.message));
            },
            (message) {
              emit(SubmitWoooApplicationSuccess(message));
            },
          );
        },
      );
    } catch (e) {
      emit(SubmitWoooApplicationError(e.toString()));
    }
  }
}
