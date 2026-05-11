import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/add_operating_account_usecase.dart';

part 'add_operating_account_event.dart';
part 'add_operating_account_state.dart';

class AddOperatingAccountBloc
    extends Bloc<AddOperatingAccountEvent, AddOperatingAccountState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final AddOperatingAccountUseCase addOperatingAccountUseCase;
  final AppLocalizationService appLocalizationService;

  AddOperatingAccountBloc({
    required this.getAuthUserUseCase,
    required this.addOperatingAccountUseCase,
    required this.appLocalizationService,
  }) : super(AddOperatingAccountInitial()) {
    on<AddOperatingAccountEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    AddOperatingAccountEvent event,
    Emitter<AddOperatingAccountState> emit,
  ) async {
    final Map<String, String> errors = {};

    if (event.accountHolderId == 0) {
      errors['dependents'] = appLocalizationService.t(
        'please_select_dependent',
      );
    }

    if (event.accountHolderInfoId == 0) {
      errors['dependentsAccounts'] = appLocalizationService.t(
        'please_select_dependent_account',
      );
    }

    if (errors.isNotEmpty) {
      emit(AddOperatingAccountValidationErrorState(errors));
      return;
    }

    emit(AddOperatingAccountProcessing());

    try {
      final authResult = await getAuthUserUseCase.call(NoParams());

      await authResult.fold(
        (failure) async {
          emit(
            AddOperatingAccountError(
              appLocalizationService.t('failed_to_load_user_info'),
            ),
          );
        },
        (authUserData) async {
          final user = authUserData.user;

          final result = await addOperatingAccountUseCase.call(
            AddOperatingAccountProps(
              email: user.loginEmail,
              userId: user.userId,
              rolePermissionId: user.roleId,
              personId: user.personId,
              employeeCode: user.employeeCode,
              mobileNumber: user.regMobile,
              operatorId: user.userId,
              accountHolderId: event.accountHolderId,
              accountHolderInfoId: event.accountHolderInfoId,
            ),
          );

          result.fold(
            (failure) {
              emit(AddOperatingAccountError(failure.message));
            },
            (message) {
              emit(AddOperatingAccountSuccess(message));
            },
          );
        },
      );
    } catch (e) {
      emit(AddOperatingAccountError('Unexpected error: ${e.toString()}'));
    }
  }
}
