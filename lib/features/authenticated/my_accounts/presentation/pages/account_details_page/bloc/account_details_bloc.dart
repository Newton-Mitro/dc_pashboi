import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/get_account_details_usecase.dart';

part 'account_details_event.dart';
part 'account_details_state.dart';

class AccountDetailsBloc
    extends Bloc<AccountDetailsEvent, AccountDetailsState> {
  final GetAccountDetailsUseCase getAccountDetailsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  AccountDetailsBloc({
    required this.getAccountDetailsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(AccountDetailsInitial()) {
    on<FetchAccountDetailsEvent>((event, emit) async {
      emit(AccountDetailsLoading());

      try {
        final authUser = await getAuthUserUseCase.call(NoParams());
        UserEntity? user;

        authUser.fold(
          (left) {
            emit(AccountDetailsError('Failed to load user information'));
          },
          (right) {
            user = right.user;
          },
        );

        if (user == null) {
          emit(AccountDetailsError('User not found'));
          return;
        }

        final dataState = await getAccountDetailsUseCase.call(
          GetAccountDetailsProps(
            email: user!.loginEmail,
            userId: user!.userId,
            rolePermissionId: user!.roleId,
            personId: user!.personId,
            employeeCode: user!.employeeCode,
            mobileNumber: user!.regMobile,
            accountNumber: event.accountNumber,
          ),
        );

        dataState.fold(
          (failure) {
            emit(AccountDetailsError(failure.message));
          },
          (myAccount) {
            emit(AccountDetailsSuccess(myAccount));
          },
        );
      } catch (e) {
        emit(AccountDetailsError('Failed to load debit card'));
      }
    });
  }
}
