part of 'submit_wooo_application_bloc.dart';

sealed class SubmitWoooApplicationEvent extends Equatable {
  const SubmitWoooApplicationEvent();

  @override
  List<Object> get props => [];
}

class SubmitWoooApplication extends SubmitWoooApplicationEvent {
  final String fromDate;
  final String toDate;
  final String rejoiningDate;
  final String reason;
  final String woooTypeCode;
  final bool isHourly;

  const SubmitWoooApplication({
    required this.fromDate,
    required this.toDate,
    required this.rejoiningDate,
    required this.reason,
    required this.woooTypeCode,
    required this.isHourly,
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
