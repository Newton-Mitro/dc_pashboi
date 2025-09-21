part of 'get_wooo_approval_bloc.dart';

sealed class GetWoooApprovalEvent extends Equatable {
  const GetWoooApprovalEvent();

  @override
  List<Object> get props => [];
}

class FetchWoooApprovalDataEvent extends GetWoooApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const FetchWoooApprovalDataEvent({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object> get props => [fromDate, toDate];
}
