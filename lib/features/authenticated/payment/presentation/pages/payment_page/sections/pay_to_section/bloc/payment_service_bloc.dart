import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/payment/domain/entities/service_entity.dart';
import 'package:pashboi/features/authenticated/payment/domain/usecases/fetch_payment_services_usecase.dart';

part 'payment_service_event.dart';
part 'payment_service_state.dart';

class PaymentServiceBloc
    extends Bloc<PaymentServiceEvent, PaymentServiceState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final FetchPaymentServicesUseCase fetchPaymentServicesUseCase;
  final AppLocalizationService appLocalizationService;

  PaymentServiceBloc({
    required this.getAuthUserUseCase,
    required this.fetchPaymentServicesUseCase,
    required this.appLocalizationService,
  }) : super(PaymentServiceInitial()) {
    on<FetchPaymentServicesEvent>(_onLoadServices);
  }

  Future<void> _onLoadServices(
    FetchPaymentServicesEvent event,
    Emitter<PaymentServiceState> emit,
  ) async {
    emit(PaymentServiceLoading());

    final user = await _getAuthenticatedUser(emit);
    if (user == null) return;

    final result = await fetchPaymentServicesUseCase.call(
      FetchPaymentServicesProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: user.roleId,
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
      ),
    );

    result.fold(
      (failure) => emit(PaymentServiceError(failure.message)),
      (paymentServices) => emit(PaymentServiceLoaded(paymentServices)),
    );
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<PaymentServiceState> emit,
  ) async {
    final authUser = await getAuthUserUseCase(NoParams());
    return authUser.fold((failure) {
      emit(
        PaymentServiceError(
          appLocalizationService.t('failed_to_load_user_info'),
        ),
      );
      return null;
    }, (success) => success.user);
  }
}
