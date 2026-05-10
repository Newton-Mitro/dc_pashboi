import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/deposit_loan_eligibility_dto.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/deposit_loan_eligibility_usecase.dart';

part 'deposit_product_loan_event.dart';
part 'deposit_product_loan_state.dart';

class DepositProductLoanBloc
    extends Bloc<DepositProductLoanEvent, DepositProductLoanState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchDepositLoanUseCase fetchDepositLoanUseCase;
  final AppLocalizationService appLocalizationService;

  DepositProductLoanBloc({
    required this.getAuthUserUseCase,
    required this.fetchDepositLoanUseCase,
    required this.appLocalizationService,
  }) : super(DepositProductLoanInitial()) {
    on<FetchDepositLoanEligibilityEvent>(_onFetchDepositLoanEligibilityEvent);
  }

  Future<void> _onFetchDepositLoanEligibilityEvent(
    FetchDepositLoanEligibilityEvent event,
    Emitter<DepositProductLoanState> emit,
  ) async {
    emit(const DepositProductLoanLoading());

    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(DepositProductLoanError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final depositLoanResult = await fetchDepositLoanUseCase.call(
          DepositLoanEligibilityProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
          ),
        );

        depositLoanResult.fold(
          (failure) {
            emit(DepositProductLoanError(failure.message));
          },
          (depositLoanResult) {
            emit(DepositProductLoanSuccess(depositLoanResult));
          },
        );
      },
    );
  }
}
