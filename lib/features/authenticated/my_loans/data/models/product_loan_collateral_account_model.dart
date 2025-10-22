import 'package:pashboi/features/authenticated/my_loans/domain/entities/product_loan_collateral_account_entity.dart';

class ProductLoanCollateralAccountModel
    extends ProductLoanCollectionAccountEntity {
  ProductLoanCollateralAccountModel({
    required super.id,
    required super.accountType,
    required super.accountNumber,
    required super.totalBalance,
    required super.loanableBalance,
    required super.partialApplyLoan,
    required super.isEligible,
    required super.withdrawableBalance,
  });

  factory ProductLoanCollateralAccountModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductLoanCollateralAccountModel(
      id: json['AccountId'] as int,
      accountType: (json['AccountType'] ?? '').toString(),
      accountNumber: (json['AccountNumber'] ?? '').toString(),
      totalBalance: (json['TotalBalance'] as num).toDouble(),
      loanableBalance: (json['LoanableBalance'] as num).toDouble(),
      partialApplyLoan: (json['PartialApplyLoan'] as num).toString(),
      isEligible: json['IsEligible'] as bool,
      withdrawableBalance: (json['WithdrawableBalance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "AccountId": id,
      "AccountType": accountType,
      "AccountNumber": accountNumber,
      "TotalBalance": totalBalance,
      "LoanableBalance": loanableBalance,
      "PartialApplyLoan": partialApplyLoan,
      "IsEligible": isEligible,
      "WithdrawableBalance": withdrawableBalance,
    };
  }
}
