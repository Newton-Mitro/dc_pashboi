part of 'update_wooo_request_bloc.dart';

sealed class UpdateWoooRequestState extends Equatable {
  const UpdateWoooRequestState();

  @override
  List<Object> get props => [];
}

final class UpdateWoooRequestInitial extends UpdateWoooRequestState {
  const UpdateWoooRequestInitial();
}

final class UpdateWoooRequestLoading extends UpdateWoooRequestState {
  const UpdateWoooRequestLoading();
}

final class UpdateWoooRequestSuccess extends UpdateWoooRequestState {
  final String message;

  const UpdateWoooRequestSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateWoooRequestError extends UpdateWoooRequestState {
  final String message;
  const UpdateWoooRequestError(this.message);
  @override
  List<Object> get props => [message];
}
