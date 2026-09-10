part of 'openable_account_bloc.dart';

sealed class OpenableAccountState extends Equatable {
  const OpenableAccountState();

  @override
  List<Object?> get props => [];
}

final class OpenableAccountInitial extends OpenableAccountState {
  const OpenableAccountInitial();
}

final class OpenableAccountLoading extends OpenableAccountState {
  const OpenableAccountLoading();
}

final class OpenableAccountSuccess extends OpenableAccountState {
  final List<OpenableAccountEntity> openableAccounts;

  const OpenableAccountSuccess(this.openableAccounts);

  @override
  List<Object?> get props => [openableAccounts];
}

final class OpenableAccountError extends OpenableAccountState {
  final String error;
  const OpenableAccountError(this.error);

  @override
  List<Object?> get props => [error];
}
