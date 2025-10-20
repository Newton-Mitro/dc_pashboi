import 'package:pashboi/core/entities/entity.dart';
import 'package:pashboi/features/authenticated/collection_ledgers/domain/entities/collection_ledger_entity.dart';

class CollateralInfoEntity extends Entity<int> {
  final List<CollectionLedgerEntity> collateralAccounts;
  final double maximumLoanAmount;
  final int numberOfInstallment;

  CollateralInfoEntity({
    required super.id,
    required this.collateralAccounts,
    required this.maximumLoanAmount,
    required this.numberOfInstallment,
  });

  @override
  List<Object?> get props => [
    id,
    collateralAccounts,
    maximumLoanAmount,
    numberOfInstallment,
  ];
}
