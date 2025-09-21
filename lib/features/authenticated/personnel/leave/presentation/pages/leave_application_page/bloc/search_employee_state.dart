part of 'search_employee_bloc.dart';

sealed class SearchEmployeeState extends Equatable {
  const SearchEmployeeState();

  @override
  List<Object> get props => [];
}

final class SearchEmployeeInitial extends SearchEmployeeState {
  const SearchEmployeeInitial();
}

final class SearchEmployeeLoading extends SearchEmployeeState {
  const SearchEmployeeLoading();
}

final class SearchEmployeeSuccess extends SearchEmployeeState {
  final List<SearchEmployeeEntity> employees;

  const SearchEmployeeSuccess(this.employees);

  @override
  List<Object> get props => [employees];
}

final class SearchEmployeeError extends SearchEmployeeState {
  final String message;

  const SearchEmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
