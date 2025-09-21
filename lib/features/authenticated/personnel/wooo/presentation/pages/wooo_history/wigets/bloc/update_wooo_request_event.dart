part of 'update_wooo_request_bloc.dart';

sealed class UpdateWoooRequestEvent extends Equatable {
  const UpdateWoooRequestEvent();

  @override
  List<Object> get props => [];
}

class UpdateWoooApplication extends UpdateWoooRequestEvent {
  final String fromDate;
  final String toDate;
  final String rejoiningDate;
  final String reason;
  final String woooTypeCode;
  final bool isHourly;
  final int leaveApplicationId;

  const UpdateWoooApplication({
    required this.fromDate,
    required this.toDate,
    required this.rejoiningDate,
    required this.reason,
    required this.woooTypeCode,
    required this.isHourly,
    required this.leaveApplicationId,
  });

  @override
  List<Object> get props => [
    fromDate,
    toDate,
    rejoiningDate,
    reason,
    woooTypeCode,
    isHourly,
  ];
}
