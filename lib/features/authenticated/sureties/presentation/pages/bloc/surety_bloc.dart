import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/sureties/domain/entities/surety_entity.dart';
import 'package:pashboi/features/authenticated/sureties/domain/usecases/fetch_given_sureties_usecase.dart';
import 'package:pashboi/features/authenticated/sureties/domain/usecases/fetch_loan_sureties_usecase.dart';

part 'surety_event.dart';
part 'surety_state.dart';

class SuretyBloc extends Bloc<SuretyEvent, SuretyState> {
  final FetchGivenSuretiesUseCase fetchGivenSuretiesUseCase;
  final FetchLoanSuretiesUseCase fetchLoanSuretiesUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  SuretyBloc({
    required this.fetchGivenSuretiesUseCase,
    required this.fetchLoanSuretiesUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(SuretyInitial()) {
    on<FetchGivenSuretiesEvent>(_fetchGivenSureties);
    on<FetchLoanSuretiesEvent>(_fetchLoanSureties);
  }

  Future<void> _fetchGivenSureties(
    FetchGivenSuretiesEvent event,
    Emitter<SuretyState> emit,
  ) async {
    emit(SuretyLoading());
    try {
      final authUser = await getAuthUserUseCase.call(NoParams());
      UserEntity? user;

      authUser.fold(
        (left) {
          emit(
            SuretyError(appLocalizationService.t('failed_to_load_user_info')),
          );
        },
        (right) {
          user = right.user;
        },
      );

      if (user == null) {
        emit(SuretyError('User not found'));
        return;
      }

      final dataState = await fetchGivenSuretiesUseCase.call(
        FetchGivenSuretiesProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: ' 56208',
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
        ),
      );

      dataState.fold(
        (failure) {
          emit(SuretyError(failure.message));
        },
        (debitCard) {
          emit(SuretyLoadingSuccess(debitCard));
        },
      );
    } catch (e) {
      emit(SuretyError('Failed to load debit card'));
    }
  }

  Future<void> _fetchLoanSureties(
    FetchLoanSuretiesEvent event,
    Emitter<SuretyState> emit,
  ) async {
    emit(SuretyLoading());
    try {
      final authUser = await getAuthUserUseCase.call(NoParams());
      UserEntity? user;

      authUser.fold(
        (left) {
          emit(
            SuretyError(appLocalizationService.t('failed_to_load_user_info')),
          );
        },
        (right) {
          user = right.user;
        },
      );

      if (user == null) {
        emit(SuretyError('User not found'));
        return;
      }

      final dataState = await fetchLoanSuretiesUseCase.call(
        FetchLoanSuretiesProps(
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
          emit(SuretyError(failure.message));
        },
        (debitCard) {
          emit(SuretyLoadingSuccess(debitCard));
        },
      );
    } catch (e) {
      emit(SuretyError('Failed to load debit card'));
    }
  }
}
