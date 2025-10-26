import 'package:pashboi/core/entities/entity.dart';
import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';

class SubmitLoanAgainstDepositProductEntity extends Entity<String> {
  final List<ProductLoanCollectionAccountEntity> collateralAccounts;
  final String loanProductCode;

  final double maximumLoanAmount;
  final double interestRate;
  final String numberOfInstallment;
  final double totalApplyLoan;
  final String secretKey;
  final String cardNo;
  final String oTPRegId;
  final String oTPValue;

  SubmitLoanAgainstDepositProductEntity({
    required this.collateralAccounts,
    required this.loanProductCode,
    required this.maximumLoanAmount,
    required this.interestRate,
    required this.numberOfInstallment,
    required this.totalApplyLoan,
    required this.secretKey,
    required this.cardNo,
    required this.oTPRegId,
    required this.oTPValue,
  });

  @override
  List<Object?> get props => [
    collateralAccounts,
    loanProductCode,
    maximumLoanAmount,
    interestRate,
    numberOfInstallment,
    totalApplyLoan,
    secretKey,
    cardNo,
    oTPRegId,
    oTPValue,
  ];
}
