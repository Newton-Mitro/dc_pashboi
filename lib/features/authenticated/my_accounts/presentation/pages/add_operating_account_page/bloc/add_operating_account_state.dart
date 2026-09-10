part of 'add_operating_account_bloc.dart';

sealed class AddOperatingAccountState extends Equatable {
  const AddOperatingAccountState();

  @override
  List<Object?> get props => [];
}

final class AddOperatingAccountInitial extends AddOperatingAccountState {
  const AddOperatingAccountInitial();
}

final class AddOperatingAccountProcessing extends AddOperatingAccountState {
  const AddOperatingAccountProcessing();
}

final class AddOperatingAccountValidationErrorState
    extends AddOperatingAccountState {
  final Map<String, dynamic> errors;
  const AddOperatingAccountValidationErrorState(this.errors);

  @override
  List<Object?> get props => [errors];
}

final class AddOperatingAccountSuccess extends AddOperatingAccountState {
  final String message;

  const AddOperatingAccountSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class AddOperatingAccountError extends AddOperatingAccountState {
  final String message;

  const AddOperatingAccountError(this.message);

  @override
  List<Object?> get props => [message];
}
