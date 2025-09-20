import 'package:pashboi/core/entities/entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/collateral_account_entity.dart';

class CollateralInfoEntity extends Entity<int> {
  final List<CollateralAccountEntity> collateralAccounts;
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
