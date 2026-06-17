import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/account_transaction_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_account_statement_usecase.dart';

part 'account_statement_event.dart';
part 'account_statement_state.dart';

class AccountStatementBloc
    extends Bloc<AccountStatementEvent, AccountStatementState> {
  final GetAccountStatementUseCase getAccountStatementUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  AccountStatementBloc({
    required this.getAccountStatementUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(AccountStatementInitial()) {
    on<FetchAccountStatementEvent>((event, emit) async {
      emit(AccountStatementLoading());

      try {
        final authUser = await getAuthUserUseCase.call(NoParams());
        UserEntity? user;

        authUser.fold(
          (left) {
            emit(
              AccountStatementError(
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
            AccountStatementError(
              appLocalizationService.t('failed_to_load_user_info'),
            ),
          );
          return;
        }

        final dataState = await getAccountStatementUseCase.call(
          GetAccountStatementProps(
            email: user!.loginEmail,
            userId: user!.userId,
            rolePermissionId: user!.roleId,
            personId: user!.personId,
            employeeCode: user!.employeeCode,
            mobileNumber: user!.regMobile,
            accountNumber: event.accountNumber,
            fromDate: event.fromDate,
            toDate: event.toDate,
          ),
        );

        dataState.fold(
          (failure) {
            emit(AccountStatementError(failure.message));
          },
          (transactions) {
            emit(AccountStatementSuccess(transactions));
          },
        );
      } catch (e) {
        emit(
          AccountStatementError(
            appLocalizationService.t('failed_to_load_debit_card'),
          ),
        );
      }
    });
  }
}
