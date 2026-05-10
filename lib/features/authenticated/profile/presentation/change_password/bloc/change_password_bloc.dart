import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';

import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/change_password_usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  ChangePasswordBloc({
    required this.changePasswordUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    final errors = <String, String>{};

    if (event.currentPassword.trim().isEmpty) {
      errors['currentPassword'] = 'Current password is required';
    }
    if (event.newPassword.trim().isEmpty) {
      errors['newPassword'] = 'New password is required';
    }
    if (event.confirmPassword.trim().isEmpty) {
      errors['confirmPassword'] = 'Confirm password is required';
    }
    if (event.newPassword != event.confirmPassword) {
      errors['confirmPassword'] = 'Passwords do not match';
    }
    if (errors.isNotEmpty) {
      emit(ChangePasswordValidationError(errors));
      return;
    }

    emit(ChangePasswordLoading());

    final userResult = await getAuthUserUseCase(NoParams());

    return userResult.fold(
      (failure) => emit(ChangePasswordError(failure.message)),
      (authUser) async {
        final props = ChangePasswordProps(
          currentPassword:
              md5.convert(utf8.encode(event.currentPassword.trim())).toString(),
          newPassword:
              md5.convert(utf8.encode(event.newPassword.trim())).toString(),
          confirmPassword:
              md5.convert(utf8.encode(event.newPassword.trim())).toString(),
          userId: authUser.user.userId,
          email: authUser.user.loginEmail,
          personId: authUser.user.personId,
          employeeCode: authUser.user.employeeCode,
          mobileNumber: authUser.user.regMobile,
          rolePermissionId: authUser.user.roleId,
        );

        final result = await changePasswordUseCase(props);

        result.fold(
          (failure) => emit(ChangePasswordError(failure.message)),
          (message) => emit(ChangePasswordSuccess(message)),
        );
      },
    );
  }
}
