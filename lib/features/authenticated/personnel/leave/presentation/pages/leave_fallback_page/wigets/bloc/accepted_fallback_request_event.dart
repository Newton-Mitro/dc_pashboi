part of 'accepted_fallback_request_bloc.dart';

sealed class AcceptedFallbackRequestEvent extends Equatable {
  const AcceptedFallbackRequestEvent();

  @override
  List<Object> get props => [];
}

class AcceptedFallbackRequestSubmitted extends AcceptedFallbackRequestEvent {
  final String remarks;
  final int leaveApplicationId;

  const AcceptedFallbackRequestSubmitted({
    required this.remarks,
    required this.leaveApplicationId,
  });

  @override
  List<Object> get props => [remarks, leaveApplicationId];
}
