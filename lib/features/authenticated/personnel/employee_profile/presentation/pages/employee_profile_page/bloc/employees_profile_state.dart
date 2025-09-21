part of 'employees_profile_bloc.dart';

abstract class EmployeesProfileState extends Equatable {
  const EmployeesProfileState();

  @override
  List<Object?> get props => [];
}

class EmployeesProfileInitial extends EmployeesProfileState {
  const EmployeesProfileInitial();
}

class EmployeesProfileLoading extends EmployeesProfileState {
  const EmployeesProfileLoading();
}

class EmployeesProfileLoaded extends EmployeesProfileState {
  final EmployeeDetailsEntity employeeDetails;

  const EmployeesProfileLoaded(this.employeeDetails);

  @override
  List<Object?> get props => [employeeDetails];
}

class EmployeesProfileError extends EmployeesProfileState {
  final String message;

  const EmployeesProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
