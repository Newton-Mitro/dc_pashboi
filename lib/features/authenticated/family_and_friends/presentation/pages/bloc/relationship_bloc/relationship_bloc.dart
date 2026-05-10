import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/entities/user_entity.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/entities/relationship_entity.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/fetch_relationships_usecase.dart';

part 'relationship_event.dart';
part 'relationship_state.dart';

class RelationshipBloc extends Bloc<RelationshipEvent, RelationshipState> {
  final FetchRelationshipsUseCase fetchRelationshipsUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  final AppLocalizationService appLocalizationService;
  RelationshipBloc({
    required this.fetchRelationshipsUseCase,
    required this.getAuthUserUseCase,
    required this.appLocalizationService,
  }) : super(RelationshipInitial()) {
    on<FetchRelationshipsEvent>((event, emit) async {
      emit(RelationshipLoading());

      try {
        final authUser = await getAuthUserUseCase.call(NoParams());
        UserEntity? user;

        authUser.fold(
          (left) {
            emit(RelationshipError('Failed to load user information'));
          },
          (right) {
            user = right.user;
          },
        );

        if (user == null) {
          emit(RelationshipError('User not found'));
          return;
        }

        final dataState = await fetchRelationshipsUseCase.call(
          FetchRelationshipsProps(
            email: user!.loginEmail,
            userId: user!.userId,
            rolePermissionId: '',
            personId: user!.personId,
            employeeCode: user!.employeeCode,
            mobileNumber: user!.regMobile,
            gender: event.gender,
          ),
        );

        dataState.fold(
          (failure) {
            emit(RelationshipError(failure.message));
          },
          (relationships) {
            emit(RelationshipLoaded(relationships));
          },
        );
      } catch (e) {
        emit(RelationshipError('Failed to load debit card'));
      }
    });
  }
}
