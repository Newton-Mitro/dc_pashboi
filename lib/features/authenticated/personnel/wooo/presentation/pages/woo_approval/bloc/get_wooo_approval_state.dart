part of 'get_wooo_approval_bloc.dart';

sealed class GetWoooApprovalState extends Equatable {
  const GetWoooApprovalState();

  @override
  List<Object> get props => [];
}

final class GetWoooApprovalInitial extends GetWoooApprovalState {
  const GetWoooApprovalInitial();
}

final class GetWoooApprovalLoading extends GetWoooApprovalState {
  const GetWoooApprovalLoading();
}

final class GetWoooApprovalSuccess extends GetWoooApprovalState {
  final List<WoooDataEntities> WoooData;

  const GetWoooApprovalSuccess(this.WoooData);

  @override
  List<Object> get props => [WoooData];
}

final class GetWoooApprovalError extends GetWoooApprovalState {
  final String message;

  const GetWoooApprovalError(this.message);

  @override
  List<Object> get props => [message];
}
