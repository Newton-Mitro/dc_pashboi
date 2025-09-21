import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/entities/search_employee_entity.dart';
import 'package:pashboi/features/authenticated/personnel/leave/domain/usecase/search_employee_usecase.dart';

part 'search_employee_event.dart';
part 'search_employee_state.dart';

class SearchEmployeeBloc
    extends Bloc<SearchEmployeeEvent, SearchEmployeeState> {
  final GetAuthUserUseCase getAuthUserUseCase;
  final SearchEmployeeUseCase searchEmployeeUseCase;
  SearchEmployeeBloc({
    required this.getAuthUserUseCase,
    required this.searchEmployeeUseCase,
  }) : super(SearchEmployeeInitial()) {
    on<FetchSearchEmployeeEvent>(_onFetchSearchEmployee);
  }

  Future<void> _onFetchSearchEmployee(
    FetchSearchEmployeeEvent event,
    Emitter<SearchEmployeeState> emit,
  ) async {
    emit(const SearchEmployeeLoading());
    final userResult = await getAuthUserUseCase.call(NoParams());

    await userResult.fold(
      (failure) async {
        emit(SearchEmployeeError(failure.message));
      },
      (authData) async {
        final user = authData.user;
        final searchResult = await searchEmployeeUseCase(
          SearchEmployee(
            email: user.loginEmail,
            userId: user.userId,
            rolePermissionId: user.roleId,
            personId: user.personId,
            employeeCode: user.employeeCode,
            mobileNumber: user.regMobile,
            searchText: event.searchText,
          ),
        );

        searchResult.fold(
          (failure) {
            emit(SearchEmployeeError(failure.message));
          },
          (employees) {
            emit(SearchEmployeeSuccess(employees));
          },
        );
      },
    );
  }
}
