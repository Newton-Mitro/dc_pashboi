import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/tenure_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_account_tenures_usecase.dart';

part 'tenure_event.dart';
part 'tenure_state.dart';

class TenureBloc extends Bloc<TenureEvent, TenureState> {
  final FetchAccountTenuresUseCase fetchAccountTenuresUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  TenureBloc({
    required this.fetchAccountTenuresUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(TenureInitial()) {
    on<FetchTenuresEvent>(_onFetchTenures);
  }

  Future<void> _onFetchTenures(
    FetchTenuresEvent event,
    Emitter<TenureState> emit,
  ) async {
    emit(TenureLoading());

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(TenureError(appLocalizationService.t('failed_to_load_user_info')));
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final accountResult = await fetchAccountTenuresUseCase.call(
        FetchAccountTenuresProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          productCode: event.productCode,
        ),
      );

      accountResult.fold(
        (failure) => emit(TenureError(failure.message)),
        (tenures) => emit(TenureSuccess(tenures)),
      );
    } catch (_) {
      emit(TenureError(appLocalizationService.t('failed_to_load_tenures')));
    }
  }
}
