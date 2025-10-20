import 'package:pashboi/core/entities/entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';

class ProductLoanEligibleCollateralAccountDto extends Entity<int> {
  final List<ProductLoanCollectionAccountEntity> collateralAccounts;
  final double maximumLoanAmount;
  final double interestRate;
  final int numberOfInstallment;
  final double totalApplyLoan;

  ProductLoanEligibleCollateralAccountDto({
    required super.id,
    required this.collateralAccounts,
    required this.maximumLoanAmount,
    required this.interestRate,
    required this.numberOfInstallment,
    required this.totalApplyLoan,
  });

  @override
  List<Object?> get props => [
    id,
    collateralAccounts,
    maximumLoanAmount,
    interestRate,
    numberOfInstallment,
    totalApplyLoan,
  ];
}
