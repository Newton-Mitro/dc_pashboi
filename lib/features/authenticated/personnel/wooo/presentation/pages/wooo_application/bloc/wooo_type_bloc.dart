import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/entities/wooo_type_entities.dart';
import 'package:pashboi/features/authenticated/personnel/wooo/domain/usecase/wooo_type_usecase.dart';

part 'wooo_type_event.dart';
part 'wooo_type_state.dart';

class WoooTypeBloc extends Bloc<WoooTypeEvent, WoooTypeState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final WoooTypeUseCase woooTypeUseCase;

  WoooTypeBloc({
    required this.getAuthUserUseCase,
    required this.woooTypeUseCase,
  }) : super(WoooTypeInitial()) {
    on<FetchWoooTypeEvent>(_onFetchWoooType);
  }

  Future<void> _onFetchWoooType(
    FetchWoooTypeEvent event,
    Emitter<WoooTypeState> emit,
  ) async {
    emit(const WoooTypeLoading());

    final userResult = await getAuthUserUseCase(NoParams());

    await userResult.fold(
      (failure) async {
        emit(WoooTypeError(failure.message));
      },
      (authData) async {
        final user = authData.user;

        final employeeResult = await woooTypeUseCase(
          WooTypeUseCaseProps(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
          ),
        );

        employeeResult.fold(
          (failure) {
            emit(WoooTypeError(failure.message));
          },
          (employee) {
            emit(WoooTypeSuccess(employee));
          },
        );
      },
    );
  }
}
