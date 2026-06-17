import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_operating_accounts_usecase.dart';

part 'fetch_operating_accounts_event.dart';
part 'fetch_operating_accounts_state.dart';

class FetchOperatingAccountsBloc
    extends Bloc<FetchOperatingAccountsEvent, FetchOperatingAccountsState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchOperatingAccountsUseCase fetchOperatingAccountUseCase;
  final AppLocalizationService appLocalizationService;

  FetchOperatingAccountsBloc({
    required this.getAuthUserUseCase,
    required this.fetchOperatingAccountUseCase,
    required this.appLocalizationService,
  }) : super(FetchOperatingAccountsInitial()) {
    on<FetchOperatingAccountsEvent>((event, emit) async {
      emit(FetchOperatingAccountsLoading());

      try {
        final authUser = await getAuthUserUseCase.call(NoParams());
        UserEntity? user;

        authUser.fold(
          (left) {
            emit(
              FetchOperatingAccountsError(
                appLocalizationService.t('failed_to_load_user_info'),
              ),
            );
          },
          (right) {
            user = right.user;
          },
        );

        if (user == null) {
          emit(
            FetchOperatingAccountsError(
              appLocalizationService.t('failed_to_load_user_info'),
            ),
          );
          return;
        }

        final dataState = await fetchOperatingAccountUseCase.call(
          FetchOperatingAccountsProps(
            email: user!.loginEmail,
            userId: user!.userId,
            rolePermissionId: user!.roleId,
            personId: user!.personId,
            employeeCode: user!.employeeCode,
            mobileNumber: user!.regMobile,
            dependentPersonId: event.dependentPersonId,
          ),
        );

        dataState.fold(
          (failure) {
            emit(FetchOperatingAccountsError(failure.message));
          },
          (myAccounts) {
            emit(FetchOperatingAccountsLoaded(myAccounts));
          },
        );
      } catch (e) {
        emit(
          FetchOperatingAccountsError(
            appLocalizationService.t('failed_to_load_debit_card'),
          ),
        );
      }
    });
  }
}
