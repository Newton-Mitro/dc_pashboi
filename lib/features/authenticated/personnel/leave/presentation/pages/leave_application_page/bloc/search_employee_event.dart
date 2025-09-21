part of 'search_employee_bloc.dart';

sealed class SearchEmployeeEvent extends Equatable {
  const SearchEmployeeEvent();

  @override
  List<Object> get props => [];
}

class FetchSearchEmployeeEvent extends SearchEmployeeEvent {
  final String searchText;
  const FetchSearchEmployeeEvent(this.searchText);
}
