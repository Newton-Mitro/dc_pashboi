import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final AppLocalizationService appLocalizationService;

  OtpVerificationBloc({
    required this.verifyOtpUseCase,
    required this.appLocalizationService,
  }) : super(OtpVerificationInitial()) {
    on<OtpChanged>((event, emit) {
      // No state change for local otp field in this version (stateless input tracking)
    });

    on<VerifyOtpSubmitted>((event, emit) async {
      emit(OtpVerificationLoading());

      final result = await verifyOtpUseCase(
        VerifyOtpParams(
          mobileNumber: event.mobileNumber,
          otpRegId: event.otpRegId,
          otpValue: event.otp,
        ),
      );

      result.fold(
        (failure) => emit(OtpVerificationFailure(failure.message)),
        (_) => emit(
          OtpVerificationSuccess(
            appLocalizationService.t('otp_verified_successfully'),
          ),
        ),
      );
    });
  }
}
