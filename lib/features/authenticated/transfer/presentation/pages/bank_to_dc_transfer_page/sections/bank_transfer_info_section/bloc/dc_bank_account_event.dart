part of 'dc_bank_account_bloc.dart';

sealed class DcBankAccountEvent extends Equatable {
  const DcBankAccountEvent();

  @override
  List<Object?> get props => [];
}

class DcBankAccountLoadEvent extends DcBankAccountEvent {
  const DcBankAccountLoadEvent();
}
