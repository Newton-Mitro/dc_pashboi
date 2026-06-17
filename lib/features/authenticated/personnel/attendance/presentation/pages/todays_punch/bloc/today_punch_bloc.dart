import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/entities/today_punch_entity.dart';
import 'package:pashboi/features/authenticated/personnel/attendance/domain/usecase/today_punch_usecase.dart';

part 'today_punch_event.dart';
part 'today_punch_state.dart';

class TodayPunchBloc extends Bloc<TodayPunchEvent, TodayPunchState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final TodayPunchUseCase todayPunchUseCase;
  final AppLocalizationService appLocalizationService;

  TodayPunchBloc({
    required this.getAuthUserUseCase,
    required this.todayPunchUseCase,
    required this.appLocalizationService,
  }) : super(TodayPunchInitial()) {
    on<TodayPunchHistory>(_fetchTodayPunch);
  }

  Future<void> _fetchTodayPunch(
    TodayPunchHistory event,
    Emitter<TodayPunchState> emit,
  ) async {
    emit(TodayPunchLoading());
    try {
      final userResult = await getAuthUserUseCase(NoParams());

      final userEntity = userResult.fold((failure) {
        emit(
          TodayPunchError(appLocalizationService.t('failed_to_load_user_info')),
        );
        return null;
      }, (success) => success.user);

      if (userEntity == null) return;

      final result = await todayPunchUseCase.call(
        TodayPunchProps(
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
        (failure) => emit(TodayPunchError(failure.message)),
        (success) => emit(TodayPunchSuccess(success)),
      );
    } catch (e) {
      emit(TodayPunchError(e.toString()));
    }
  }
}
