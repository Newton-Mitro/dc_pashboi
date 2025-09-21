part of 'employees_profile_bloc.dart';

abstract class EmployeesProfileEvent extends Equatable {
  const EmployeesProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeDetailsEvent extends EmployeesProfileEvent {
  const FetchEmployeeDetailsEvent();
}
