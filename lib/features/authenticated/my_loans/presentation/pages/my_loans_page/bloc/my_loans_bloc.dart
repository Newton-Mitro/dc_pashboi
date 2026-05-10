import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_my_loans_usecase.dart';

part 'my_loans_event.dart';
part 'my_loans_state.dart';

class MyLoansBloc extends Bloc<MyLoansEvent, MyLoansState> {
  final FetchMyLoansUseCase fetchMyLoansUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  MyLoansBloc({
    required this.fetchMyLoansUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(MyLoansInitial()) {
    on<FetchMyLoansEvent>((event, emit) async {
      emit(MyLoansLoading());

      try {
        final authUser = await getAuthUserUseCase.call(NoParams());
        UserEntity? user;

        authUser.fold(
          (left) {
            emit(MyLoansError('Failed to load user information'));
          },
          (right) {
            user = right.user;
          },
        );

        if (user == null) {
          emit(MyLoansError('User not found'));
          return;
        }

        final dataState = await fetchMyLoansUseCase.call(
          FetchMyLoansProps(
            email: user!.loginEmail,
            userId: user!.userId,
            rolePermissionId: user!.roleId,
            personId: user!.personId,
            employeeCode: user!.employeeCode,
            mobileNumber: user!.regMobile,
          ),
        );

        dataState.fold(
          (failure) {
            emit(MyLoansError(failure.message));
          },
          (myLoans) {
            emit(MyLoansLoaded(myLoans));
          },
        );
      } catch (e) {
        emit(MyLoansError('Failed to load debit card'));
      }
    });
  }
}
