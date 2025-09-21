part of 'leave_application_bloc.dart';

abstract class LeaveApplicationEvent extends Equatable {
  const LeaveApplicationEvent();

  @override
  List<Object> get props => [];
}

class LeaveApplicationUpdateField extends LeaveApplicationEvent {
  final Map<String, dynamic> data;

  const LeaveApplicationUpdateField({required this.data});

  @override
  List<Object> get props => [data];
}

class LeaveApplicationSubmitEvent extends LeaveApplicationEvent {}
