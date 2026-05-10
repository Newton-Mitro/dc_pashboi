import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/entities/deposit_account_entity.dart';
import 'package:pashboi/features/authenticated/my_accounts/domain/usecases/fetch_dependents_usecase.dart';

part 'fetch_dependents_event.dart';
part 'fetch_dependents_state.dart';

class FetchDependentsBloc
    extends Bloc<FetchDependentsEvent, FetchDependentsState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchDependentsUseCase fetchDependentsUseCase;
  final AppLocalizationService appLocalizationService;

  FetchDependentsBloc({
    required this.getAuthUserUseCase,
    required this.fetchDependentsUseCase,
    required this.appLocalizationService,
  }) : super(FetchDependentsInitial()) {
    on<FetchDependentsEvent>(_onFetchDependents);
  }

  Future<void> _onFetchDependents(
    FetchDependentsEvent event,
    Emitter<FetchDependentsState> emit,
  ) async {
    emit(FetchDependentsLoading());

    try {
      final authResult = await getAuthUserUseCase.call(NoParams());

      return authResult.fold(
        (failure) {
          emit(FetchDependentsError('Failed to load user information'));
        },
        (authUserData) async {
          final user = authUserData.user;

          final dependentsResult = await fetchDependentsUseCase.call(
            FetchDependentsProps(
              email: user.loginEmail,
              userId: user.userId,
              rolePermissionId: user.roleId,
              personId: user.personId,
              employeeCode: user.employeeCode,
              mobileNumber: user.regMobile,
              dependentPersonId: -1,
            ),
          );

          dependentsResult.fold(
            (failure) {
              emit(FetchDependentsError(failure.message));
            },
            (dependents) {
              emit(FetchDependentsLoaded(dependents));
            },
          );
        },
      );
    } catch (e) {
      emit(FetchDependentsError('Unexpected error: ${e.toString()}'));
    }
  }
}
