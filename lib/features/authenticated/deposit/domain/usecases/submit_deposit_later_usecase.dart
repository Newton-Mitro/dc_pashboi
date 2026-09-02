import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/repositories/deposit_repository.dart';

class SubmitDepositLaterProps extends BaseRequestProps {
  final String accountNumber;
  final String accountHolderName;
  final String repeatMonths;
  final int accountId;
  final String accountType;
  final String cardNumber;
  final String depositDate;
  final int dayOfMonth;
  final int ledgerId;
  final String cardPin;
  final double totalDepositAmount;
  final String otpRegId;
  final String otpValue;
  final String? nameOnCard;

  final List<CollectionLedgerEntity>? collectionLedgers;

  const SubmitDepositLaterProps({
    required this.accountNumber,
    required this.nameOnCard,
    required this.accountHolderName,
    required this.accountId,
    required this.accountType,
    required this.cardNumber,
    required this.depositDate,
    required this.repeatMonths,
    required this.dayOfMonth,
    required this.ledgerId,
    required this.cardPin,
    required this.totalDepositAmount,
    required this.otpRegId,
    required this.otpValue,
    required this.collectionLedgers,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class SubmitDepositLaterUseCase
    extends UseCase<String, SubmitDepositLaterProps> {
  final DepositRepository depositRepository;

  SubmitDepositLaterUseCase({required this.depositRepository});

  @override
  ResultFuture<String> call(SubmitDepositLaterProps props) async {
    return depositRepository.submitDepositLater(props);
  }
}
