import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/against_loan_interest_entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/usecases/fetch_against_loan_interest_usecase.dart';

part 'fetch_against_loan_interest_event.dart';
part 'fetch_against_loan_interest_state.dart';

class FetchAgainstLoanInterestBloc
    extends Bloc<FetchAgainstLoanInterestEvent, FetchAgainstLoanInterestState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchAgainstLoanInterestUseCase fetchAgainstLoanInterestUseCase;
  final AppLocalizationService appLocalizationService;

  FetchAgainstLoanInterestBloc({
    required this.getAuthUserUseCase,
    required this.fetchAgainstLoanInterestUseCase,
    required this.appLocalizationService,
  }) : super(FetchAgainstLoanInterestInitial()) {
    on<FetchAgainstLoanInterest>(_onFetchAgainstLoanInterestEvent);
  }

  Future<void> _onFetchAgainstLoanInterestEvent(
    FetchAgainstLoanInterest event,
    Emitter<FetchAgainstLoanInterestState> emit,
  ) async {
    emit(const FetchAgainstLoanInterestLoading());

    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(FetchAgainstLoanInterestError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final loanInterest = await fetchAgainstLoanInterestUseCase.call(
          FetchAgainstLoanInterestProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
            productCode: event.productCode,
            accountIds: event.accountIds,
          ),
        );

        loanInterest.fold(
          (failure) {
            emit(FetchAgainstLoanInterestError(failure.message));
          },
          (loanInterest) {
            emit(FetchAgainstLoanInterestSuccess(loanInterest));
          },
        );
      },
    );
  }
}
