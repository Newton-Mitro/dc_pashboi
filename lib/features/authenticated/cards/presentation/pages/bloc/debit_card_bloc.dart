import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/entities/debit_card_entity.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/get_my_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/lock_the_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/re_issue_debit_card_usecase.dart';
import 'package:pashboi/features/authenticated/cards/domain/usecases/verify_card_pin_usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';

part 'debit_card_event.dart';
part 'debit_card_state.dart';

class DebitCardBloc extends Bloc<DebitCardEvent, DebitCardState> {
  final GetMyCardUseCase getMyCardUseCase;
  final IssueDebitCardUseCase issueDebitCardUseCase;
  final ReIssueDebitCardUsecase reIssueDebitCardUsecase;
  final LockTheCardUseCase lockTheCardUseCase;
  final VerifyCardPinUseCase verifyCardPinUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;

  late UserEntity? user;

  DebitCardBloc({
    required this.getMyCardUseCase,
    required this.issueDebitCardUseCase,
    required this.reIssueDebitCardUsecase,
    required this.lockTheCardUseCase,
    required this.verifyCardPinUseCase,
    required this.getAuthUserUseCase,
  }) : super(const DebitCardState()) {
    on<DebitCardLoad>(_onLoad);
    on<DebitCardIssue>(_onIssue);
    on<DebitCardReIssue>(_onReIssue);
    on<DebitCardBlock>(_onBlock);
    on<DebitCardPinVerify>(_onPinVerify);
  }

  Future<UserEntity?> _getUser(Emitter<DebitCardState> emit) async {
    final authResult = await getAuthUserUseCase.call(NoParams());
    UserEntity? userEntity;

    authResult.fold(
      (failure) =>
          emit(state.copyWith(error: 'Failed to load user information')),
      (authData) => userEntity = authData.user,
    );

    return userEntity;
  }

  Future<void> _onLoad(
    DebitCardLoad event,
    Emitter<DebitCardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      user = await _getUser(emit);
      if (user == null) return;

      final dataState = await getMyCardUseCase.call(
        GetMyCardUseCaseProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: user!.roleId,
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
        ),
      );

      dataState.fold(
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)),
        (debitCard) =>
            emit(state.copyWith(isLoading: false, debitCard: debitCard)),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Failed to load debit card'),
      );
    }
  }

  Future<void> _onIssue(
    DebitCardIssue event,
    Emitter<DebitCardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      user ??= await _getUser(emit);
      if (user == null) return;

      final result = await issueDebitCardUseCase.call(
        IssueDebitCardUseCaseProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: user!.roleId,
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
          cardTypeCode: event.cardTypeCode,
          withCard: event.withCard,
        ),
      );

      result.fold(
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)),
        (_) => emit(
          state.copyWith(
            isLoading: false,
            successMessage: 'Card issued successfully',
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Card issue failed'));
    }
  }

  Future<void> _onReIssue(
    DebitCardReIssue event,
    Emitter<DebitCardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      final result = await reIssueDebitCardUsecase.call(
        ReIssueDebitCardUsecaseProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: user!.roleId,
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
          cardTypeCode: event.cardTypeCode,
          cardNumber: event.cardNumber,
          virtualCard: event.virtualCard,
          nameOnCard: event.nameOnCard,
        ),
      );

      result.fold(
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)),
        (_) => emit(
          state.copyWith(
            isLoading: false,
            successMessage: 'Card reissued successfully',
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Card reissue failed'));
    }
  }

  Future<void> _onBlock(
    DebitCardBlock event,
    Emitter<DebitCardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      user ??= await _getUser(emit);
      if (user == null) return;

      final result = await lockTheCardUseCase.call(
        LockTheCardUseCaseProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: user!.roleId,
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
          cardNumber: event.cardNumber,
          accountNumber: event.accountNumber,
          nameOnCard: event.nameOnCard,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            successMessage: null,
          ),
        ),
        (_) => emit(
          state.copyWith(
            isLoading: false,
            successMessage: 'Card blocked successfully',
            error: null,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to block card',
          successMessage: null,
        ),
      );
    }
  }

  Future<void> _onPinVerify(
    DebitCardPinVerify event,
    Emitter<DebitCardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      user ??= await _getUser(emit);
      if (user == null) return;

      final result = await verifyCardPinUseCase.call(
        VerifyCardPinUseCaseProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: user!.roleId,
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
          cardNumber: event.cardNumber,
          nameOnCard: event.nameOnCard,
          cardPIN: md5.convert(utf8.encode(event.cardPIN.trim())).toString(),
          accountNumber: event.accountNumber,
        ),
      );

      result.fold(
        (failure) async {
          final updatedAttempts = state.pinAttempts + 1;

          if (updatedAttempts >= 3) {
            // Trigger card block event after 3 failures
            add(
              DebitCardBlock(
                cardNumber: event.cardNumber,
                accountNumber: event.accountNumber,
                nameOnCard: event.nameOnCard,
              ),
            );

            emit(
              state.copyWith(
                isLoading: false,
                error: 'Card blocked after 3 incorrect PIN attempts',
                pinAttempts: updatedAttempts,
                successMessage: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoading: false,
                error: 'Incorrect PIN. Attempt $updatedAttempts of 3.',
                successMessage: null,
                pinAttempts: updatedAttempts,
              ),
            );
          }
        },
        (pinRegId) => emit(
          state.copyWith(
            isLoading: false,
            successMessage: pinRegId,
            error: null,
            pinAttempts: 0, // reset on success
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'PIN verification failed',
          successMessage: null,
        ),
      );
    }
  }
}
