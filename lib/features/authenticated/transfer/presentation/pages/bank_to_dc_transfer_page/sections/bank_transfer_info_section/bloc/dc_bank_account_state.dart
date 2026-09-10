part of 'dc_bank_account_bloc.dart';

sealed class DcBankAccountState extends Equatable {
  const DcBankAccountState();

  @override
  List<Object?> get props => [];
}

final class DcBankAccountInitial extends DcBankAccountState {
  const DcBankAccountInitial();
}

final class DcBankAccountLoading extends DcBankAccountState {
  const DcBankAccountLoading();
}

final class DcBankAccountLoaded extends DcBankAccountState {
  final List<DcBankEntity> dcBankAccounts;
  const DcBankAccountLoaded(this.dcBankAccounts);

  @override
  List<Object?> get props => [dcBankAccounts];
}

final class DcBankAccountError extends DcBankAccountState {
  final String message;
  const DcBankAccountError(this.message);

  @override
  List<Object?> get props => [message];
}
