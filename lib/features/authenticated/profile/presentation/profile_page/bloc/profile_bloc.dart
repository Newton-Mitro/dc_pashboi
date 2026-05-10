import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/profile/domain/entities/person_entity.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/get_profile_usecase.dart';
import 'package:pashboi/features/authenticated/profile/domain/usecases/update_profile_image_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileImageUseCase updateProfileImageUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;

  PersonEntity? personEntity;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileImageUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(const ProfileState()) {
    on<FetchProfileEvent>(_onLoadProfile);
    on<UpdateProfileImageEvent>(_onUpdateProfileImage);
  }

  Future<void> _onLoadProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final authUserResult = await getAuthUserUseCase.call(NoParams());

    await authUserResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Failed to load user information',
          ),
        );
      },
      (authData) async {
        final user = authData.user;

        final profileResult = await getProfileUseCase.call(
          GetProfileProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
          ),
        );

        profileResult.fold(
          (failure) =>
              emit(state.copyWith(isLoading: false, error: failure.message)),
          (person) {
            personEntity = person;
            emit(
              state.copyWith(
                isLoading: false,
                personEntity: person,
                error: null,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final authUserResult = await getAuthUserUseCase.call(NoParams());

    await authUserResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Failed to load user information',
          ),
        );
      },
      (authData) async {
        final user = authData.user;

        final updateResult = await updateProfileImageUseCase.call(
          UpdateProfileImageProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
            imageData: event.imageData,
          ),
        );

        updateResult.fold(
          (failure) =>
              emit(state.copyWith(isLoading: false, error: failure.message)),
          (_) {
            if (personEntity != null) {
              final updatedPerson = personEntity!.copyWith(
                photo: event.imageData,
              );
              personEntity = updatedPerson;
              emit(
                state.copyWith(
                  isLoading: false,
                  personEntity: updatedPerson,
                  error: null,
                ),
              );
            } else {
              emit(state.copyWith(isLoading: false));
            }
          },
        );
      },
    );
  }
}
