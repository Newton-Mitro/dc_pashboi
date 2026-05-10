import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/entities/loan_payment_entity.dart';
import 'package:pashboi/features/authenticated/loan_payment/domain/usecases/fetch_loan_payment_usecase.dart';

part 'loan_payment_event.dart';
part 'loan_payment_state.dart';

class LoanPaymentBloc extends Bloc<LoanPaymentEvent, LoanPaymentState> {
  final FetchLoanPaymentUseCase fetchLoanPaymentUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  LoanPaymentBloc({
    required this.fetchLoanPaymentUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(LoanPaymentInitial()) {
    on<FetchLoanPayment>(_onFetchLoanPayment);
  }

  Future<void> _onFetchLoanPayment(
    FetchLoanPayment event,
    Emitter<LoanPaymentState> emit,
  ) async {
    emit(LoanPaymentLoading());

    final authResult = await getAuthUserUseCase.call(NoParams());

    await authResult.fold(
      (authFailure) async {
        emit(LoanPaymentError(message: 'Failed to authenticate user'));
      },
      (authData) async {
        final user = authData.user;

        final loanResult = await fetchLoanPaymentUseCase.call(
          FetchLoanPaymentProps(
            loanNumber: event.loanNumber,
            interestDays: event.interestDays,
            interestRate: event.interestRate,
            loanBalance: event.loanBalance,
            loanRefundAmount: event.loanRefundAmount,
            moduleCode: event.moduleCode,
            issuedDate: event.issuedDate,
            lastPaidDate: event.lastPaidDate,
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
          ),
        );

        loanResult.fold(
          (loanFailure) => emit(LoanPaymentError(message: loanFailure.message)),
          (loanPayment) => emit(LoanPaymentLoaded(loanPayment: loanPayment)),
        );
      },
    );
  }
}
