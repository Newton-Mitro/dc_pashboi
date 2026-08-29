import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/transfer/domain/repositories/transfer_repository.dart';

class SubmitTransferBankToDcProps extends BaseRequestProps {
  final String accountNumber;
  final String accountHolderName;
  final int accountId;
  final int ledgerId;

  final String toBankAccountNumber;
  final String bankRoutingNumber;

  final String transactionReceipt;
  final String transactionNumber;
  final String depositDate;
  final double totalDepositAmount;

  final String cardNumber;
  final String nameOnCard;
  final String cardPin;

  final String otpRegId;
  final String otpValue;

  final List<CollectionLedgerEntity> collectionLedgers;

  const SubmitTransferBankToDcProps({
    required this.accountNumber,
    required this.accountHolderName,
    required this.bankRoutingNumber,
    required this.transactionReceipt,
    required this.transactionNumber,
    required this.accountId,
    required this.cardNumber,
    required this.depositDate,
    required this.ledgerId,
    required this.cardPin,
    required this.totalDepositAmount,
    required this.otpRegId,
    required this.otpValue,
    required this.toBankAccountNumber,
    required this.nameOnCard,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
    required this.collectionLedgers,
  });
}

class SubmitTransferBankToDcUseCase
    extends UseCase<String, SubmitTransferBankToDcProps> {
  final TransferRepository transferRepository;

  SubmitTransferBankToDcUseCase({required this.transferRepository});

  @override
  ResultFuture<String> call(SubmitTransferBankToDcProps props) async {
    return transferRepository.submitTransferBankToDc(props);
  }
}
