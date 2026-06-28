import 'package:pashboi/core/requests/base_request_props.dart';
import 'package:pashboi/core/types/typedef.dart';
import 'package:pashboi/core/usecases/usecase.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/entities/bkash_payment_entity.dart';
import 'package:pashboi/features/authenticated/deposit/domain/repositories/deposit_repository.dart';

class SubmitDepositFromBkashProps extends BaseRequestProps {
  final double totalDepositAmount;
  final String transactionMethod;
  final String transactionType;
  final double serviceCharge;

  final List<CollectionLedgerEntity>? collectionLedgers;

  const SubmitDepositFromBkashProps({
    required this.totalDepositAmount,
    required this.transactionMethod,
    required this.transactionType,
    required this.collectionLedgers,
    required this.serviceCharge,
    required super.email,
    required super.userId,
    required super.rolePermissionId,
    required super.personId,
    required super.employeeCode,
    required super.mobileNumber,
  });
}

class SubmitDepositFromBkashUseCase
    extends UseCase<BkashPaymentEntity, SubmitDepositFromBkashProps> {
  final DepositRepository depositRepository;

  SubmitDepositFromBkashUseCase({required this.depositRepository});

  @override
  ResultFuture<BkashPaymentEntity> call(
    SubmitDepositFromBkashProps props,
  ) async {
    return depositRepository.submitDepositFromBkash(props);
  }
}
