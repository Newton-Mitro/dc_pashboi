import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/repositories/deposit_repository.dart';

class SubmitDepositNowProps extends BaseRequestProps {
  final String accountNumber;
  final String accountHolderName;
  final int accountId;
  final String accountType;
  final String cardNumber;
  final String depositDate;
  final int ledgerId;
  final double totalDepositAmount;
  final String cardPin;
  final String transactionMethod;
  final String otpRegId;
  final String otpValue;
  final String transactionType;

  final List<CollectionLedgerEntity>? collectionLedgers;

  const SubmitDepositNowProps({
    required this.accountNumber,
    required this.accountHolderName,
    required this.accountId,
    required this.accountType,
    required this.cardNumber,
    required this.depositDate,
    required this.ledgerId,
    required this.cardPin,
    required this.totalDepositAmount,
    required this.transactionMethod,
    required this.otpRegId,
    required this.otpValue,
    required this.transactionType,
    required this.collectionLedgers,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class SubmitDepositNowUseCase extends UseCase<String, SubmitDepositNowProps> {
  final DepositRepository depositRepository;

  SubmitDepositNowUseCase({required this.depositRepository});

  @override
  ResultFuture<String> call(SubmitDepositNowProps props) async {
    return depositRepository.submitDepositNow(props);
  }
}
