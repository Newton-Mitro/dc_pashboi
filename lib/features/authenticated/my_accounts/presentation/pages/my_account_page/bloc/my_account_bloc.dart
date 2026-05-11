import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_my_accounts_usecase.dart';

part 'my_account_event.dart';
part 'my_account_state.dart';

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  final GetMyAccountsUseCase getMyAccountsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  MyAccountBloc({
    required this.getMyAccountsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(MyAccountInitial()) {
    on<FetchMyAccountEvent>(_onFetchMyAccount);
  }

  Future<void> _onFetchMyAccount(
    FetchMyAccountEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    emit(MyAccountLoading());

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(
          MyAccountError(appLocalizationService.t('failed_to_load_user_info')),
        );
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final accountResult = await getMyAccountsUseCase.call(
        GetMyAccountsProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: "6,1,1210", // You can later parametrize this
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
          accountHolderPersonId:
              event.accountHolderPersonId == 0
                  ? user.personId
                  : event.accountHolderPersonId,
        ),
      );

      accountResult.fold(
        (failure) => emit(MyAccountError(failure.message)),
        (accounts) => emit(MyAccountSuccess(accounts)),
      );
    } catch (_) {
      emit(MyAccountError(appLocalizationService.t('failed_to_load_accounts')));
    }
  }
}
