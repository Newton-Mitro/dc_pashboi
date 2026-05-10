import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/agm_counter/domain/entities/agm_counter_entity.dart';
import 'package:pashboi/features/authenticated/agm_counter/domain/usecases/fetch_agm_counter_info_usecase.dart';

part 'agm_counter_event.dart';
part 'agm_counter_state.dart';

class AgmCounterBloc extends Bloc<AgmCounterEvent, AgmCounterState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchAGMCounterInfoUseCase fetchAgmCounterInfoUseCase;
  final AppLocalizationService appLocalizationService;

  AgmCounterBloc({
    required this.getAuthUserUseCase,
    required this.fetchAgmCounterInfoUseCase,
    required this.appLocalizationService,
  }) : super(AgmCounterInitial()) {
    on<FetchAgmCounterInfoEvent>(_onFetchAgmCounterInfo);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<AgmCounterState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      emit(const AgmCounterInfoError('Failed to load user information'));
      return null;
    }, (success) => success.user);
  }

  Future<void> _onFetchAgmCounterInfo(
    FetchAgmCounterInfoEvent event,
    Emitter<AgmCounterState> emit,
  ) async {
    emit(AgmCounterInfoLoading());

    final user = await _getAuthenticatedUser(emit);
    if (user == null) return;

    final result = await fetchAgmCounterInfoUseCase.call(
      FetchAGMCounterInfoProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
        accountNo: event.accountNo,
      ),
    );

    result.fold(
      (failure) => emit(AgmCounterInfoError(failure.message)),
      (agmCounters) => emit(AgmCounterInfoLoaded(agmCounters)),
    );
  }
}
