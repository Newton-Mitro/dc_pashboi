import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/entities/family_and_friend_entity.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/get_family_and_friends_usecase.dart';

part 'family_and_relatives_event.dart';
part 'family_and_relatives_state.dart';

class FamilyAndRelativesBloc
    extends Bloc<FamilyAndRelativesEvent, FamilyAndRelativesState> {
  final GetFamilyAndFriendsUseCase getFamilyAndFriendsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  FamilyAndRelativesBloc({
    required this.getFamilyAndFriendsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(FamilyAndRelativesInitial()) {
    on<FetchFamilyAndRelatives>(_onFetchFamilyAndFriends);
  }

  Future<UserEntity?> _getAuthenticatedUser(
    Emitter<FamilyAndRelativesState> emit,
  ) async {
    final authUser = await getAuthUserUseCase.call(NoParams());

    return authUser.fold((failure) {
      emit(const FamilyAndRelativesFailure('Failed to load user information'));
      return null;
    }, (success) => success.user);
  }

  Future<void> _onFetchFamilyAndFriends(
    FetchFamilyAndRelatives event,
    Emitter<FamilyAndRelativesState> emit,
  ) async {
    emit(FamilyAndRelativesLoading());

    final user = await _getAuthenticatedUser(emit);
    if (user == null) return;

    final result = await getFamilyAndFriendsUseCase.call(
      GetFamilyAndFriendsProps(
        email: user.loginEmail,
        userId: user.userId,
        rolePermissionId: '',
        personId: user.personId,
        employeeCode: user.employeeCode,
        mobileNumber: user.regMobile,
        includeSelf: false,
      ),
    );

    result.fold(
      (failure) => emit(FamilyAndRelativesFailure(failure.message)),
      (familyAndFriends) =>
          emit(FamilyAndRelativesLoaded(familyAndFriends: familyAndFriends)),
    );
  }
}
