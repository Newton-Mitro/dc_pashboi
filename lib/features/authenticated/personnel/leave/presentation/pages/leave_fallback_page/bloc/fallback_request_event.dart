part of 'fallback_request_bloc.dart';

sealed class FallbackRequestEvent extends Equatable {
  const FallbackRequestEvent();

  @override
  List<Object> get props => [];
}

final class FetchFallbackRequests extends FallbackRequestEvent {
  const FetchFallbackRequests();
}
