import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/tenure_amount_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_account_tenure_amounts_usecase.dart';

part 'tenure_amount_event.dart';
part 'tenure_amount_state.dart';

class TenureAmountBloc extends Bloc<TenureAmountEvent, TenureAmountState> {
  final FetchAccountTenureAmountsUseCase fetchAccountTenureAmountsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  TenureAmountBloc({
    required this.fetchAccountTenureAmountsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(TenureAmountInitial()) {
    on<FetchTenureAmountsEvent>(_onFetchTenureAmounts);
  }

  Future<void> _onFetchTenureAmounts(
    FetchTenureAmountsEvent event,
    Emitter<TenureAmountState> emit,
  ) async {
    emit(TenureAmountLoading());

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(
          TenureAmountError(
            appLocalizationService.t('failed_to_load_user_info'),
          ),
        );
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final accountResult = await fetchAccountTenureAmountsUseCase.call(
        FetchAccountTenureAmountsProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          productCode: event.productCode,
          duration: event.duration,
        ),
      );

      accountResult.fold(
        (failure) => emit(TenureAmountError(failure.message)),
        (tenures) => emit(TenureAmountSuccess(tenures)),
      );
    } catch (_) {
      emit(TenureAmountError('Failed to load tenures'));
    }
  }
}
