import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/add_family_and_friend_usecase.dart';

part 'add_family_and_relative_event.dart';
part 'add_family_and_relative_state.dart';

class AddFamilyAndRelativeBloc
    extends Bloc<AddFamilyAndRelativeEvent, AddFamilyAndRelativeState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final AddFamilyAndFriendUsecase addFamilyAndFriendUseCase;
  final AppLocalizationService appLocalizationService;

  AddFamilyAndRelativeBloc({
    required this.getAuthUserUseCase,
    required this.addFamilyAndFriendUseCase,
    required this.appLocalizationService,
  }) : super(AddFamilyAndRelativeInitial()) {
    on<AddFamilyAndRelativeSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    AddFamilyAndRelativeSubmitted event,
    Emitter<AddFamilyAndRelativeState> emit,
  ) async {
    emit(AddFamilyAndRelativeLoading());
    final relationTypeCode = event.relationTypeCode;
    final childPersonId = event.childPersonId;

    final Map<String, String> errors = {};

    if (event.searchAccountNumber.isEmpty) {
      errors['searchAccountNumber'] = 'Please enter search account number';
    }

    if (relationTypeCode.isEmpty) {
      errors['relationTypeCode'] = 'Please enter relationship';
    }

    if (childPersonId == 0) {
      errors['memberName'] = "Please search with a valid account number";
    }

    if (errors.isNotEmpty) {
      emit(AddFamilyAndRelativeValidationErrorState(errors));
      return;
    }

    try {
      final authUser = await getAuthUserUseCase.call(NoParams());
      UserEntity? user;

      authUser.fold(
        (left) {
          emit(AddFamilyAndRelativeFailure('Failed to load user information'));
        },
        (right) {
          user = right.user;
        },
      );

      if (user == null) {
        emit(AddFamilyAndRelativeFailure('User not found'));
        return;
      }

      final dataState = await addFamilyAndFriendUseCase.call(
        AddFamilyAndFriendProps(
          email: user!.loginEmail,
          userId: user!.userId,
          rolePermissionId: user!.roleId,
          personId: user!.personId,
          employeeCode: user!.employeeCode,
          mobileNumber: user!.regMobile,
          childPersonId: childPersonId,
          relationTypeCode: relationTypeCode,
        ),
      );

      dataState.fold(
        (failure) {
          emit(AddFamilyAndRelativeFailure(failure.message));
        },
        (_) {
          emit(AddFamilyAndRelativeSuccess());
        },
      );
    } catch (e) {
      emit(AddFamilyAndRelativeFailure('Failed to load debit card'));
    }
  }
}
