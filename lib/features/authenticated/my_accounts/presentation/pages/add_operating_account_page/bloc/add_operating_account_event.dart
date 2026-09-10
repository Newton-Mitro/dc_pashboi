part of 'add_operating_account_bloc.dart';

final class AddOperatingAccountEvent extends Equatable {
  final int accountHolderId;
  final int accountHolderInfoId;

  const AddOperatingAccountEvent({
    required this.accountHolderId,
    required this.accountHolderInfoId,
  });

  @override
  List<Object?> get props => [accountHolderId, accountHolderInfoId];
}
