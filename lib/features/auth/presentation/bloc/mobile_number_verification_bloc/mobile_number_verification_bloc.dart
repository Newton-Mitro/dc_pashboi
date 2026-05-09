import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/features/auth/domain/usecases/verify_mobile_number_usecase.dart';
part 'mobile_number_verification_event.dart';
part 'mobile_number_verification_state.dart';

class VerifyMobileNumberBloc
    extends Bloc<VerifyMobileNumberEvent, VerifyMobileNumberState> {
  final VerifyMobileNumberUseCase verifyMobileNumberUseCase;

  VerifyMobileNumberBloc({required this.verifyMobileNumberUseCase})
    : super(VerifyMobileNumberInitial()) {
    on<SubmitMobileNumber>(_onSubmitMobileNumber);
  }

  Future<void> _onSubmitMobileNumber(
    SubmitMobileNumber event,
    Emitter<VerifyMobileNumberState> emit,
  ) async {
    emit(VerifyMobileNumberLoading());

    final result = await verifyMobileNumberUseCase.call(
      VerifyMobileNumberParams(
        mobileNumber: event.mobileNumber,
        isRegistered: event.isRegistered,
      ),
    );

    result.fold(
      (failure) => emit(VerifyMobileNumberFailure(failure.message)),
      (message) => emit(VerifyMobileNumberSuccess(message)),
    );
  }
}
