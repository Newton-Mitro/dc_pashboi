part of 'fallback_request_bloc.dart';

sealed class FallbackRequestState extends Equatable {
  const FallbackRequestState();

  @override
  List<Object> get props => [];
}

final class FallbackRequestInitial extends FallbackRequestState {
  const FallbackRequestInitial();
}

final class FallbackRequestLoading extends FallbackRequestState {
  const FallbackRequestLoading();
}

final class FallbackRequestSuccess extends FallbackRequestState {
  final List<LeaveApplicationEntities> requests;

  const FallbackRequestSuccess(this.requests);

  @override
  List<Object> get props => [requests];
}

final class FallbackRequestError extends FallbackRequestState {
  final String message;

  const FallbackRequestError(this.message);

  @override
  List<Object> get props => [message];
}
