part of 'wooo_type_bloc.dart';

sealed class WoooTypeState extends Equatable {
  const WoooTypeState();

  @override
  List<Object> get props => [];
}

final class WoooTypeInitial extends WoooTypeState {
  const WoooTypeInitial();
}

final class WoooTypeLoading extends WoooTypeState {
  const WoooTypeLoading();
}

final class WoooTypeSuccess extends WoooTypeState {
  final List<WoooTypeEntities> woooTypeEntities;

  const WoooTypeSuccess(this.woooTypeEntities);

  @override
  List<Object> get props => [woooTypeEntities];
}

final class WoooTypeError extends WoooTypeState {
  final String message;

  const WoooTypeError(this.message);

  @override
  List<Object> get props => [message];
}
