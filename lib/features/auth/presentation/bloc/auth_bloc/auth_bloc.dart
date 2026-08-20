import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/core/utils/crypto_helper.dart';
import 'package:pashboi/features/auth/domain/entities/auth_user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/login_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  AuthBloc({
    required this.loginUseCase,
    required this.getAuthUserUseCase,
    required this.logoutUseCase,
    required this.appLocalizationService,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<AuthUserCheck>(_onAuthUserCheck);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    // Local input validation
    final errors = <String, String>{};

    if (event.username.trim().isEmpty) {
      errors['email'] = appLocalizationService.t('email_required');
    } else if (!_isValidEmail(event.username)) {
      errors['email'] = appLocalizationService.t('valid_email_required');
    }

    if (event.password.trim().isEmpty) {
      errors['password'] = appLocalizationService.t('password_required');
    }

    if (errors.isNotEmpty) {
      emit(AuthValidationErrorState(errors));
      return;
    }
    emit(AuthLoading());
    final loginParams = LoginParams(
      email: event.username,
      password: CryptoHelper.md5Hash(event.password),
    );

    final dataState = await loginUseCase.call(loginParams);

    dataState.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AuthValidationErrorState(failure.errors));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (authUser) {
        emit(Authenticated(authUser));
      },
    );
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase.call(NoParams());
    emit(UnAuthenticated());
  }

  Future<void> _onAuthUserCheck(
    AuthUserCheck event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getAuthUserUseCase.call(NoParams());

    result.fold(
      (failure) {
        emit(UnAuthenticated());
      },
      (authUser) {
        emit(Authenticated(authUser));
      },
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }
}
