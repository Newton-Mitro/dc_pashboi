import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/transfer/domain/entities/dc_bank_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/usecases/fetch_dc_accounts_usecase.dart';

part 'dc_bank_account_event.dart';
part 'dc_bank_account_state.dart';

class DcBankAccountBloc extends Bloc<DcBankAccountEvent, DcBankAccountState> {
  final FetchDcBankAccountsUseCase fetchDcBankAccountsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  DcBankAccountBloc({
    required this.fetchDcBankAccountsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(DcBankAccountInitial()) {
    on<DcBankAccountLoadEvent>(_fetchDcBankAccounts);
  }

  Future<void> _fetchDcBankAccounts(
    DcBankAccountLoadEvent event,
    Emitter<DcBankAccountState> emit,
  ) async {
    emit(DcBankAccountLoading());

    try {
      final authUserResult = await getAuthUserUseCase.call(NoParams());

      if (authUserResult.isLeft()) {
        emit(DcBankAccountError('Failed to load user information'));
        return;
      }

      final user = authUserResult.getOrElse(() => throw Exception()).user;

      final accountResult = await fetchDcBankAccountsUseCase.call(
        FetchDcBankAccountsProps(
          email: user.loginEmail,
          userId: user.userId,
          rolePermissionId: user.roleId,
          personId: user.personId,
          employeeCode: user.employeeCode,
          mobileNumber: user.regMobile,
        ),
      );

      accountResult.fold(
        (failure) => emit(DcBankAccountError(failure.message)),
        (accounts) => emit(DcBankAccountLoaded(accounts)),
      );
    } catch (_) {
      emit(DcBankAccountError('Failed to load DC bank accounts'));
    }
  }
}
