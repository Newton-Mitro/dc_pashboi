import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/entities/employee_details_entity.dart';
import 'package:pashboi/features/authenticated/personnel/employee_profile/domain/usecase/employee_details_usecase.dart';

part 'employees_profile_event.dart';
part 'employees_profile_state.dart';

class EmployeesProfileBloc
    extends Bloc<EmployeesProfileEvent, EmployeesProfileState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final EmployeeDetailsUseCase employeeDetailsUseCase;

  EmployeesProfileBloc({
    required this.employeeDetailsUseCase,
    required this.getAuthUserUseCase,
  }) : super(const EmployeesProfileInitial()) {
    on<FetchEmployeeDetailsEvent>(_onFetchEmployeeDetails);
  }

  Future<void> _onFetchEmployeeDetails(
    FetchEmployeeDetailsEvent event,
    Emitter<EmployeesProfileState> emit,
  ) async {
    emit(const EmployeesProfileLoading());

    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(EmployeesProfileError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final employeeResult = await employeeDetailsUseCase(
          EmployeeDetailsProps(
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
            emit(EmployeesProfileError(failure.message));
          },
          (employee) {
            emit(EmployeesProfileLoaded(employee));
          },
        );
      },
    );
  }
}
