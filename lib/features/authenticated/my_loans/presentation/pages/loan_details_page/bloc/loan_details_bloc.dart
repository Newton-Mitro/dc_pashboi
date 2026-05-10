import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/loan_account_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_loan_details_usecase.dart';

part 'loan_details_event.dart';
part 'loan_details_state.dart';

class LoanDetsilsBloc extends Bloc<LoanDetsilsEvent, LoanDetailsState> {
  final FetchLoanDetailsUseCase fetchLoanDetailsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  LoanDetsilsBloc({
    required this.fetchLoanDetailsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(LoanDetailsInitial()) {
    on<FetchLoanDetsilsEvent>((event, emit) async {
      emit(LoanDetsilsLoading());

      try {
        final authUser = await getAuthUserUseCase.call(NoParams());
        UserEntity? user;

        authUser.fold(
          (left) {
            emit(
              LoanDetailsError(
                appLocalizationService.t('failed_to_load_user_info'),
              ),
            );
          },
          (right) {
            user = right.user;
          },
        );

        if (user == null) {
          emit(LoanDetailsError('User not found'));
          return;
        }

        final dataState = await fetchLoanDetailsUseCase.call(
          FetchLoanDetailsProps(
            email: user!.loginEmail,
            userId: user!.userId,
            rolePermissionId: user!.roleId,
            personId: user!.personId,
            employeeCode: user!.employeeCode,
            mobileNumber: user!.regMobile,
            loanNumber: event.loanNumber,
          ),
        );

        dataState.fold(
          (failure) {
            emit(LoanDetailsError(failure.message));
          },
          (loan) {
            emit(LoanDetailsSuccess(loan));
          },
        );
      } catch (e) {
        emit(LoanDetailsError('Failed to load debit card'));
      }
    });
  }
}
