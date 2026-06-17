import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_registered_mobile_usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/reset_password_usecase.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetRegisteredMobileUseCase getRegisteredMobileUseCase;
  final AppLocalizationService appLocalizationService;

  ResetPasswordBloc({
    required this.resetPasswordUseCase,
    required this.getRegisteredMobileUseCase,
    required this.appLocalizationService,
  }) : super(ResetPasswordInitial()) {
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<GetRegisteredMobileRequested>(_onGetRegisteredMobileRequested);
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    // Local form validation
    final errors = <String, String>{};

    if (event.mobileNumber.trim().isEmpty) {
      errors['mobile'] = appLocalizationService.t('mobile_number_is_required');
    } else if (!_isValidMobileNumber(event.mobileNumber)) {
      errors['mobile'] = appLocalizationService.t('enter_valid_mobile_number');
    }

    if (event.password.trim().isEmpty) {
      errors['password'] = appLocalizationService.t('password_required');
    } else if (event.password.length < 6) {
      errors['password'] = appLocalizationService.t(
        'password_must_be_at_least_6_characters',
      );
    }

    if (errors.isNotEmpty) {
      emit(ResetPasswordValidationError(errors));
      return;
    }

    emit(ResetPasswordLoading());

    // 🔐 Encrypt password with MD5
    final encryptedPassword =
        md5.convert(utf8.encode(event.password)).toString();

    final result = await resetPasswordUseCase(
      ResetPasswordParams(
        mobileNumber: event.mobileNumber,
        password: encryptedPassword,
      ),
    );

    result.fold((failure) {
      if (failure is ValidationFailure) {
        emit(ResetPasswordValidationError(failure.errors));
      } else {
        emit(ResetPasswordFailure(message: failure.message));
      }
    }, (_) => emit(ResetPasswordSuccess()));
  }

  Future<void> _onGetRegisteredMobileRequested(
    GetRegisteredMobileRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());

    final result = await getRegisteredMobileUseCase(NoParams());

    result.fold(
      (failure) => emit(ResetPasswordFailure(message: failure.message)),
      (mobile) => emit(RegisteredMobileLoaded(mobile)),
    );
  }

  bool _isValidMobileNumber(String number) {
    final mobileRegex = RegExp(r'^\d{10,15}$'); // You can customize this
    return mobileRegex.hasMatch(number);
  }
}
