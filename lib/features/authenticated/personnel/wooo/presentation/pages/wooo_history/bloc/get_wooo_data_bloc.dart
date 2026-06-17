import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_data_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/get_wooo_usecase.dart';

part 'get_wooo_data_event.dart';
part 'get_wooo_data_state.dart';

class GetWoooDataBloc extends Bloc<FetchWoooDataEvent, GetWoooDataState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final GetWoooDataUseCase getWoooDataUseCase;
  final AppLocalizationService appLocalizationService;

  GetWoooDataBloc({
    required this.getAuthUserUseCase,
    required this.getWoooDataUseCase,
    required this.appLocalizationService,
  }) : super(GetWoooDataInitial()) {
    on<FetchWoooDataEvent>(_getWoooHistory);
  }
  Future<void> _getWoooHistory(
    FetchWoooDataEvent event,
    Emitter<GetWoooDataState> emit,
  ) async {
    emit(GetWoooDataLoading());

    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(GetWoooDataError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final WoooHistoryResult = await getWoooDataUseCase(
          GetWoooProps(
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
            emit(GetWoooDataError(failure.message));
          },
          (WoooData) {
            emit(GetWoooDataSuccess(WoooData));
          },
        );
      },
    );
  }
}
