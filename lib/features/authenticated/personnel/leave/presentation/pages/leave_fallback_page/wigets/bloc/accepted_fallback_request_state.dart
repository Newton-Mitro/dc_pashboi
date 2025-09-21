part of 'accepted_fallback_request_bloc.dart';

sealed class AcceptedFallbackRequestState extends Equatable {
  const AcceptedFallbackRequestState();

  @override
  List<Object> get props => [];
}

final class AcceptedFallbackRequestInitial
    extends AcceptedFallbackRequestState {
  const AcceptedFallbackRequestInitial();
}

final class AcceptedFallbackRequestLoading
    extends AcceptedFallbackRequestState {
  const AcceptedFallbackRequestLoading();
}

final class AcceptedFallbackRequestSuccess
    extends AcceptedFallbackRequestState {
  final String message;

  const AcceptedFallbackRequestSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class AcceptedFallbackRequestError extends AcceptedFallbackRequestState {
  final String message;

  const AcceptedFallbackRequestError(this.message);

  @override
  List<Object> get props => [message];
}
