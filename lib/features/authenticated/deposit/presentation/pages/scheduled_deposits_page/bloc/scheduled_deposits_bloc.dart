import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/deposit/domain/entities/voucher_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/usecases/fetch_scheduled_deposits_usecase.dart';

part 'scheduled_deposits_event.dart';
part 'scheduled_deposits_state.dart';

class ScheduledDepositsBloc
    extends Bloc<ScheduledDepositsEvent, ScheduledDepositsState> {
  final FetchScheduledDepositsUseCase fetchScheduledDepositsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  ScheduledDepositsBloc({
    required this.fetchScheduledDepositsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(ScheduledDepositsInitial()) {
    on<FetchScheduledDeposits>(_fetchScheduledRequests);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<ScheduledDepositsState> emit,
  ) async {
    final authUser = await getAuthUserUseCase.call(NoParams());

    return authUser.fold((failure) {
      emit(const ScheduledDepositsFailure('Failed to load user information'));
      return null;
    }, (success) => success.user);
  }

  Future<void> _fetchScheduledRequests(
    FetchScheduledDeposits event,
    Emitter<ScheduledDepositsState> emit,
  ) async {
    emit(ScheduledDepositsLoading());

    final user = await _getAuthenticatedUser(emit);
    if (user == null) return;

    final result = await fetchScheduledDepositsUseCase.call(
      FetchScheduledDepositsProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
        otherField: '',
      ),
    );

    result.fold(
      (failure) => emit(ScheduledDepositsFailure(failure.message)),
      (scheduledRequests) =>
          emit(ScheduledDepositsLoaded(depositRequests: scheduledRequests)),
    );
  }
}
