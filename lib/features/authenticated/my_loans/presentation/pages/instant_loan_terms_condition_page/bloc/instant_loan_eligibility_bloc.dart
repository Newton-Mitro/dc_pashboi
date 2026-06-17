import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/instant_loan_eligibility_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/check_instant_loan_eligibility_usecase.dart';

part 'instant_loan_eligibility_event.dart';
part 'instant_loan_eligibility_state.dart';

class InstantLoanEligibilityBloc
    extends Bloc<InstantLoanEligibilityEvent, InstantLoanEligibilityState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final InstantLoanEligibilityUseCase instantLoanEligibilityUseCase;
  final AppLocalizationService appLocalizationService;

  InstantLoanEligibilityBloc({
    required this.getAuthUserUseCase,
    required this.instantLoanEligibilityUseCase,
    required this.appLocalizationService,
  }) : super(InstantLoanEligibilityInitial()) {
    on<FetchInstantLoanEligibilityEvent>(_onFetchInstantLoanEligibilityEvent);
  }
  Future<void> _onFetchInstantLoanEligibilityEvent(
    FetchInstantLoanEligibilityEvent event,
    Emitter<InstantLoanEligibilityState> emit,
  ) async {
    emit(const InstantLoanEligibilityLoading());

    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(InstantLoanEligibilityError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final leaveTypeBalanceResult = await instantLoanEligibilityUseCase.call(
          InstantLoanEligibilityProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
          ),
        );

        leaveTypeBalanceResult.fold(
          (failure) {
            emit(InstantLoanEligibilityError(failure.message));
          },
          (leaveTypeBalance) {
            emit(InstantLoanEligibilitySuccess(leaveTypeBalance));
          },
        );
      },
    );
  }
}
