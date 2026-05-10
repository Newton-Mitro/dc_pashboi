import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/registration_usecase.dart';

part 'registration_page_event.dart';
part 'registration_page_state.dart';

class RegistrationPageBloc
    extends Bloc<RegistrationPageEvent, RegistrationPageState> {
  final RegistrationUseCase registrationUseCase;
  final AppLocalizationService appLocalizationService;

  RegistrationPageBloc({
    required this.registrationUseCase,
    required this.appLocalizationService,
  }) : super(RegistrationInitialState()) {
    on<RegisterEvent>((event, emit) async {
      emit(RegistrationLoadingState());
      final registrationParams = RegistrationParams(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      final result = await registrationUseCase.call(registrationParams);

      result.fold(
        (failure) {
          if (failure is ValidationFailure) {
            emit(RegistrationValidationErrorState(failure.errors));
          } else {
            emit(RegistrationErrorState(failure.message));
          }
        },
        (data) {
          emit(RegistrationSuccessState(data));
        },
      );
    });
  }
}
