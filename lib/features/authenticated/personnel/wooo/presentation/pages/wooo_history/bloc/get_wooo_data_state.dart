part of 'get_wooo_data_bloc.dart';

sealed class GetWoooDataState extends Equatable {
  const GetWoooDataState();

  @override
  List<Object> get props => [];
}

final class GetWoooDataInitial extends GetWoooDataState {
  const GetWoooDataInitial();
}

final class GetWoooDataLoading extends GetWoooDataState {
  const GetWoooDataLoading();
}

final class GetWoooDataSuccess extends GetWoooDataState {
  final List<WoooDataEntities> WoooData;

  const GetWoooDataSuccess(this.WoooData);

  @override
  List<Object> get props => [WoooData];
}

final class GetWoooDataError extends GetWoooDataState {
  final String message;

  const GetWoooDataError(this.message);

  @override
  List<Object> get props => [message];
}
